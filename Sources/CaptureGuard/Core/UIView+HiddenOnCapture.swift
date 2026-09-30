//
//  UIView+HiddenOnCapture.swift
//

import UIKit
import ObjectiveC

@MainActor
private var captureGuardPreviousAlphaKey: UInt8 = 0

@MainActor
extension UIView {
	var captureGuardPreviousAlpha: CGFloat? {
		get {
			guard let number = objc_getAssociatedObject(self, &captureGuardPreviousAlphaKey) as? NSNumber else {
				return nil
			}
			return CGFloat(number.doubleValue)
		}
		set {
			let number = newValue.map { NSNumber(value: Double($0)) }
			objc_setAssociatedObject(self, &captureGuardPreviousAlphaKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}

public extension UIView {

    /// Hides this view, and everything inside it, from screenshots, recordings and
    /// mirrored streams.
    func makeHiddenOnCapture() {
        layer.makeHiddenOnCapture()
        CaptureMonitor.shared.hideWhileCapturing(self)
    }
}
