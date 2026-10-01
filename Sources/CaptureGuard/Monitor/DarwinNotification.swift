//
//  DarwinNotification.swift
//

import Foundation

#if canImport(CNotify)
import CNotify
#endif

struct DarwinNotification {

	private let token: Int32

	/// `nil` when registration fails, so the caller can fall back.
	init?(_ name: String, onChange: @escaping () -> Void) {
		var token: Int32 = 0
		guard notify_register_dispatch(name, &token, .main, { _ in onChange() }) == 0 else {
			return nil
		}
		self.token = token
	}

	/// `nil` when the state cannot be read.
	var state: UInt64? {
		var state: UInt64 = 0
		guard notify_get_state(token, &state) == 0 else { return nil }
		return state
	}
}
