//
//  ContentView.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import SwiftUI
import CaptureGuard

struct ContentView: View {

	@ObservedObject private var monitor = CaptureMonitor.shared

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			Text("Screenshot me.")
				.font(.largeTitle.weight(.semibold))

			Text("SwiftUI. Take a screenshot, then compare it with what you see now.")
				.foregroundStyle(.secondary)

			secret("Card number", "4929 8823 1147 0021")
			secret("One-time code", "704 118")

			state
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.padding()
	}

	/// Live state, so you can watch it change when a capture starts.
	private var state: some View {
		VStack(alignment: .leading, spacing: 2) {
			Text("isCapturing      \(String(monitor.isCapturing))")
			Text("isHidingContent  \(String(monitor.isHidingContent))")
		}
		.font(.system(.footnote, design: .monospaced))
		.foregroundStyle(.secondary)
	}

	/// One call hides the value from screenshots, recordings and mirrored streams.
	private func secret(_ title: String, _ value: String) -> some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title)
				.font(.caption)
				.foregroundStyle(.secondary)

			mono(value).hiddenOnCapture()
		}
		.padding()
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
	}

	private func mono(_ text: String) -> some View {
		Text(text).font(.system(.title3, design: .monospaced))
	}
}

#Preview {
	ContentView()
}
