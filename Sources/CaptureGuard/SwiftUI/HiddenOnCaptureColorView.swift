//
//  HiddenOnCaptureColorView.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import SwiftUI

struct HiddenOnCaptureColorView: UIViewRepresentable {
	
	let color: UIColor
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.layer.makeHiddenOnCapture()
		updateViewColor(view: view)
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
		updateViewColor(view: uiView)
	}
	
	func updateViewColor(view: UIView) {
		view.backgroundColor = color
	}
}
