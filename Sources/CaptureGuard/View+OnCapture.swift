//
//  View+OnCapture.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import SwiftUI

/// Modifier that makes the view visible only on screenshot or screen capture
public struct VisibleOnlyOnCaptureModifier: ViewModifier {
	
	public init() { }
	
	public func body(content: Content) -> some View {
		content.mask {
			ZStack {
				Color.white
				HiddenOnCaptureColorView(color: .black)
			}
			.compositingGroup()
			.luminanceToAlpha()
		}
	}
}

public extension View {
	/// Makes the view visible only on screenshot or screen capture
	func visibleOnlyOnCapture() -> some View {
		modifier(VisibleOnlyOnCaptureModifier())
	}
}

/// Modifier that makes the view hidden on screenshot or screen capture
public struct HiddenOnCaptureModifier: ViewModifier {
	
	public init() { }
	
	public func body(content: Content) -> some View {
		content.mask {
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
	/// Makes the view hidden on screenshot or screen capture
	func hiddenOnCapture() -> some View {
		modifier(HiddenOnCaptureModifier())
	}
}
