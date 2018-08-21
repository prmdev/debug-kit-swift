//
//  AppDelegate.swift
//  DebugKitExample
//
//  Created by Aaron Sky on 8/19/18.
//

import UIKit
import DebugKit

private struct PrivateModule: DebugPresentable {
    static let name = "Private Module"
    static let icon: UIImage? = nil

    static func createViewController() -> UIViewController {
        return UIViewController()
    }

    static func searchResultsWithinModule(for query: String) -> [SearchResult] {
        return []
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DebugKit.register(AppDebugModule.self)
        DebugKit.register(PrivateModule.self)
        return true
    }
}
