//
//  SceneDelegate.swift
//
//  Created by Kirill Sidorov on 20.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene, willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let _ = (scene as? UIWindowScene) else { return }
	}

	func sceneDidDisconnect(_ scene: UIScene) { }

	func sceneDidBecomeActive(_ scene: UIScene) { }

	func sceneWillResignActive(_ scene: UIScene) { }

	func sceneWillEnterForeground(_ scene: UIScene) { }

	func sceneDidEnterBackground(_ scene: UIScene) { }
	
}

