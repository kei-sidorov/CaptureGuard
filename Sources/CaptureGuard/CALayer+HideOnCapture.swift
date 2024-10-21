//
//  CALayer+HideOnCapture.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import UIKit

private let uiKitTextField = UITextField()
private var captureSecuredView: UIView?

public extension CALayer {
	func makeHiddenOnCapture() {
		let captureSecuredView: UIView? = captureSecuredView
			?? uiKitTextField.subviews.first(where: { NSStringFromClass(type(of: $0)).contains("LayoutCanvasView") })
		
		let originalLayer = captureSecuredView?.layer
		captureSecuredView?.setValue(self, forKey: "layer")
		uiKitTextField.isSecureTextEntry = false
		uiKitTextField.isSecureTextEntry = true
		captureSecuredView?.setValue(originalLayer, forKey: "layer")
	}
}
