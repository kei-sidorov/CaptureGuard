//
//  LayerFilterFactory.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import UIKit

enum LayerFilter: String {
	case luminanceToAlpha
}

enum LayerFilterFactory {

	static func makeFilter(_ filter: LayerFilter) -> NSObject? {
		guard let filterClass: AnyClass = NSClassFromString("CAFilter") else { return nil }
		let selector = Selector("filterWithName:")
		typealias Function = @convention(c) (AnyClass, Selector, String) -> AnyObject?
		
		guard let filterWithName = class_getClassMethod(filterClass, selector) else { return nil }

		let implementation = method_getImplementation(filterWithName)
		let function = unsafeBitCast(implementation, to: Function.self)
		
		guard let filter = function(filterClass, selector, filter.rawValue) as? NSObject else { return nil }
		return filter
	}
	
}
