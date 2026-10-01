//
//  ViewController.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import UIKit
import CaptureGuard
import CaptureGuardUIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let page = UIStackView(arrangedSubviews: [
			title("Screenshot me."),
			caption("UIKit. Take a screenshot, then compare it with what you see now.", style: .body),
			secret("Card number", "4929 8823 1147 0021"),
			secret("One-time code", "704 118"),
			subclassCard()
		])
		page.axis = .vertical
		page.spacing = 20
		page.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(page)

		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			page.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
			page.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
			page.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
		])
	}

	private func subclassCard() -> UIView {
		let card = HiddenOnCaptureView()
		card.backgroundColor = .secondarySystemBackground
		card.layer.cornerRadius = 12
		pin(mono("ridge fabric mutual dawn"), in: card, inset: 16)

		let stampLabel = mono("CAPTURED")
		stampLabel.textColor = .systemRed
		let stamp = VisibleOnlyOnCaptureView()
		pin(stampLabel, in: stamp, inset: 0)

		let box = UIView()
		pin(card, in: box, inset: 0)
		stamp.translatesAutoresizingMaskIntoConstraints = false
		box.addSubview(stamp)
		NSLayoutConstraint.activate([
			stamp.centerXAnchor.constraint(equalTo: box.centerXAnchor),
			stamp.centerYAnchor.constraint(equalTo: box.centerYAnchor)
		])
		return box
	}

	private func pin(_ view: UIView, in parent: UIView, inset: CGFloat) {
		view.translatesAutoresizingMaskIntoConstraints = false
		parent.addSubview(view)
		NSLayoutConstraint.activate([
			view.topAnchor.constraint(equalTo: parent.topAnchor, constant: inset),
			view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: inset),
			view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -inset),
			view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -inset)
		])
	}

	private func secret(_ name: String, _ value: String) -> UIView {
		let value = mono(value)
		value.makeHiddenOnCapture()

		let card = UIStackView(arrangedSubviews: [caption(name, style: .caption1), value])
		card.axis = .vertical
		card.spacing = 6
		card.isLayoutMarginsRelativeArrangement = true
		card.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
		card.backgroundColor = .secondarySystemBackground
		card.layer.cornerRadius = 12
		return card
	}

	private func title(_ text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = UIFontMetrics(forTextStyle: .largeTitle)
			.scaledFont(for: .systemFont(ofSize: 34, weight: .semibold))
		label.adjustsFontForContentSizeCategory = true
		label.numberOfLines = 0
		return label
	}

	private func caption(_ text: String, style: UIFont.TextStyle) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = .preferredFont(forTextStyle: style)
		label.adjustsFontForContentSizeCategory = true
		label.textColor = .secondaryLabel
		label.numberOfLines = 0
		return label
	}

	private func mono(_ text: String) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = .monospacedSystemFont(ofSize: 20, weight: .medium)
		return label
	}
}
