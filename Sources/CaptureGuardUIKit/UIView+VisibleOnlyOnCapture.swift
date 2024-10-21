//
//  UIView+VisibleOnlyOnCapture.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import UIKit
import CaptureGuard

/// UIView that is visible only on screen capture on screenshots
open class VisibleOnlyOnCaptureView: UIView {
	
	private lazy var whiteLayer: CALayer = {
		let layer = CALayer()
		layer.backgroundColor = UIColor.white.cgColor
		return layer
	}()
	
	private lazy var blackLayer: CALayer = {
		let layer = CALayer()
		layer.backgroundColor = UIColor.black.cgColor
		layer.makeHiddenOnCapture()
		return layer
	}()
	
	private lazy var maskLayer: CALayer = {
		let layer = CALayer()
		layer.addSublayer(whiteLayer)
		layer.addSublayer(blackLayer)
		if let filter = LayerFilterFactory.makeFilter(.luminanceToAlpha) {
			layer.perform(Selector(("setFilters:")), with: [filter])
		}
		return layer
	}()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		layer.mask = maskLayer
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		layer.mask = maskLayer
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		maskLayer.frame = bounds
		whiteLayer.frame = bounds
		blackLayer.frame = bounds
	}
}

/// UIView that is hidden on screen capture on screenshots
open class HiddenOnCaptureView: UIView {
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		layer.makeHiddenOnCapture()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		layer.makeHiddenOnCapture()
	}
	
}
