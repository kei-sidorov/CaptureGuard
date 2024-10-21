//
//  ViewController.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import UIKit
import CaptureGuardUIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var stackView: UIStackView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// A sample of programmatically created views
		
		let hiddenOnCaptureView = HiddenOnCaptureView()
		// alternatively, you can use the `makeHiddenOnCapture()` method on any UIView's layer
		hiddenOnCaptureView.backgroundColor = .red
		hiddenOnCaptureView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		hiddenOnCaptureView.heightAnchor.constraint(equalToConstant: 40).isActive = true
		stackView.addArrangedSubview(hiddenOnCaptureView)
		
		let visibleOnlyOnCaptureView = VisibleOnlyOnCaptureView()
		visibleOnlyOnCaptureView.backgroundColor = .green
		visibleOnlyOnCaptureView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		visibleOnlyOnCaptureView.heightAnchor.constraint(equalToConstant: 40).isActive = true
		stackView.addArrangedSubview(visibleOnlyOnCaptureView)
		
	}

}

