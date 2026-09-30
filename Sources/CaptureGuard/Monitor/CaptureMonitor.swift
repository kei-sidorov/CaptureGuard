//
//  CaptureMonitor.swift
//

import UIKit
import Combine
import GameController

/// Reports whether the screen is being captured right now.
@MainActor
public final class CaptureMonitor: ObservableObject {

	public static let shared = CaptureMonitor()

	/// True while a capture is running: recording, AirPlay, or iPhone Mirroring.
	@Published public private(set) var isCapturing: Bool = false
	/// True while protected views are hidden: a capture, or the app not being active.
	@Published public private(set) var isHidingContent: Bool = false

	/// Whether to guess at iPhone Mirroring. On by default, because iOS never reports
	/// mirroring as a capture. The guess is undocumented and may break on an iOS release.
	public var detectsMirroring: Bool = true {
		didSet {
			if !detectsMirroring {
				hasSeenMirroring = false
				mirroringMouse = nil
				isAwaitingDisplayOnAfterMouseDisconnect = false
				ignoresDisplayStatusAfterMouseDisconnect = false
			}
			refresh()
		}
	}

	private var observers: [NSObjectProtocol] = []
	private let protectedViews = NSHashTable<UIView>.weakObjects()
	private var hasSeenMirroring = false
	private var mirroringMouse: GCMouse?
	private var isAwaitingDisplayOnAfterMouseDisconnect = false
	private var ignoresDisplayStatusAfterMouseDisconnect = false
	private var isActive = true
	private var displayStatus: DarwinNotification?

	private init() {
		isActive = UIApplication.shared.applicationState == .active

		let names: [Notification.Name] = [
			UIScreen.capturedDidChangeNotification,
			UIScreen.brightnessDidChangeNotification,
			UIApplication.didBecomeActiveNotification,
			UIApplication.willResignActiveNotification,
			UIApplication.willEnterForegroundNotification,
			UIApplication.didEnterBackgroundNotification,
			.GCMouseDidConnect,
			.GCMouseDidDisconnect
		]
		observers = names.map { name in
			NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] notification in
				MainActor.assumeIsolated {
					guard let self else { return }
					switch name {
					case UIApplication.didBecomeActiveNotification:
						self.isActive = true
					case UIApplication.willResignActiveNotification,
						 UIApplication.didEnterBackgroundNotification:
						self.isActive = false
					default:
						break
					}
					if name == UIApplication.didEnterBackgroundNotification {
						self.hasSeenMirroring = false
						self.mirroringMouse = nil
						self.isAwaitingDisplayOnAfterMouseDisconnect = false
						self.ignoresDisplayStatusAfterMouseDisconnect = false
					}
					if name == .GCMouseDidDisconnect {
						self.handleMirroringMouseDisconnect(notification)
					}
					self.refresh()
				}
			}
		}
		displayStatus = DarwinNotification("com.apple.iokit.hid.displayStatus") { [weak self] in
			MainActor.assumeIsolated {
				guard let self else { return }
				if self.isAwaitingDisplayOnAfterMouseDisconnect,
				   self.displayStatus?.state == 1 {
					self.hasSeenMirroring = false
					self.isAwaitingDisplayOnAfterMouseDisconnect = false
					self.ignoresDisplayStatusAfterMouseDisconnect = true
				}
				self.refresh()
			}
		}

		refresh()
	}

	func hideWhileCapturing(_ view: UIView) {
		protectedViews.add(view)
		if isHidingContent, view.captureGuardPreviousAlpha == nil {
			view.captureGuardPreviousAlpha = view.alpha
			view.alpha = 0
		}
	}

	public func refresh() {
		refreshMirroringState()
		let capturing = isSystemCapturing || (detectsMirroring && hasSeenMirroring)
		let hiding = capturing || !isActive

		if capturing != isCapturing {
			isCapturing = capturing
		}
		let changed = hiding != isHidingContent
		isHidingContent = hiding

		guard hiding || changed else { return }
		for view in protectedViews.allObjects {
			if hiding {
				if changed || view.captureGuardPreviousAlpha == nil || view.alpha != 0 {
					view.captureGuardPreviousAlpha = view.alpha
				}
				view.alpha = 0
			} else if changed, let alpha = view.captureGuardPreviousAlpha {
				view.alpha = alpha
				view.captureGuardPreviousAlpha = nil
			}
		}
	}

	private func refreshMirroringState() {
		guard detectsMirroring, isActive else { return }

		let mouse = GCMouse.mice().first {
			$0.vendorName?.contains(mirroringMouseName) == true
		}
		if let mouse {
			hasSeenMirroring = true
			mirroringMouse = mouse
			isAwaitingDisplayOnAfterMouseDisconnect = false
			ignoresDisplayStatusAfterMouseDisconnect = false
		} else if isAwaitingDisplayOnAfterMouseDisconnect {
			hasSeenMirroring = true
		} else if !ignoresDisplayStatusAfterMouseDisconnect && looksLikeMirroring() {
			hasSeenMirroring = true
		}
	}

	private func handleMirroringMouseDisconnect(_ notification: Notification) {
		guard let disconnectedMouse = notification.object as? GCMouse,
			  let observedMouse = mirroringMouse,
			  disconnectedMouse === observedMouse,
			  disconnectedMouse.vendorName?.contains(mirroringMouseName) == true else { return }

		// Keep hiding while the display is still off; a fresh screen-on state confirms the end.
		self.mirroringMouse = nil
		ignoresDisplayStatusAfterMouseDisconnect = true
		if displayStatus?.state == 1 {
			hasSeenMirroring = false
		} else {
			hasSeenMirroring = true
			isAwaitingDisplayOnAfterMouseDisconnect = true
		}
	}

	/// Set by recording, AirPlay and Mac-side screen recording. Not by iPhone Mirroring.
	private var isSystemCapturing: Bool {
		screens.contains { $0.isCaptured }
	}

	/// Vendor name of the virtual mouse iOS makes for a mirroring session. Undocumented.
	private let mirroringMouseName = "iPhone Mirroring"

	private func looksLikeMirroring() -> Bool {
		#if targetEnvironment(simulator)
		return false
		#else
		guard isActive else { return false }

		// Or the panel being dark while the app is in front.
		if let isDisplayOn = displayStatus?.state, isDisplayOn == 0 { return true }

		if displayStatus == nil { return activeScreen.brightness <= 0.001 }
		return false
		#endif
	}

	/// One screen per connected scene, or the main screen when there are none.
	private var screens: [UIScreen] {
		let sceneScreens = windowScenes.map(\.screen)
		return sceneScreens.isEmpty ? [UIScreen.main] : sceneScreens
	}

	private var activeScreen: UIScreen {
		let scenes = windowScenes
		return (scenes.first { $0.activationState == .foregroundActive } ?? scenes.first)?.screen ?? UIScreen.main
	}

	private var windowScenes: [UIWindowScene] {
		UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
	}
}
