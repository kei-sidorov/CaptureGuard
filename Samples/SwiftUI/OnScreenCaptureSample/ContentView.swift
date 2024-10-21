//
//  ContentView.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import SwiftUI
import CaptureGuard

struct ContentView: View {
	var body: some View {
		VStack {
			Text("Hidden on capture")
				.hiddenOnCapture()
			
			Text("Visible only on capture")
				.visibleOnlyOnCapture()
		}
		.font(.largeTitle)
	}
}
	
#Preview {
	ContentView()
}
