//
//  HiddenOnCaptureView.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import UIKit
import CaptureGuard

/// UIView that is hidden from screenshots, recordings and mirrored streams
open class HiddenOnCaptureView: UIView {
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		makeHiddenOnCapture()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		makeHiddenOnCapture()
	}
	
}
