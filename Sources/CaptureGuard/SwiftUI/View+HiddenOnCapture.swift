//
//  View+HiddenOnCapture.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import SwiftUI

/// Modifier that makes the view hidden from screenshots, recordings and mirrored streams
public struct HiddenOnCaptureModifier: ViewModifier {
	
	@ObservedObject private var monitor = CaptureMonitor.shared
	
	public init() { }
	
	public func body(content: Content) -> some View {
		content
			.opacity(monitor.isHidingContent ? 0 : 1)
			.allowsHitTesting(!monitor.isHidingContent)
			.accessibilityHidden(monitor.isHidingContent)
			.mask {
				ZStack {
					Color.black
					HiddenOnCaptureColorView(color: .white)
				}
				.compositingGroup()
				.luminanceToAlpha()
			}
	}
}

public extension View {
	/// Makes the view hidden on screenshot, screen recording or a mirrored stream
	func hiddenOnCapture() -> some View {
		modifier(HiddenOnCaptureModifier())
	}
}
