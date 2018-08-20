//
//  AppDelegate.swift
//  DebugKitExample
//
//  Created by Aaron Sky on 8/19/18.
//

import UIKit
import DebugKit

private struct PrivateModule: DebugModule {
    static let name = "Private Module"
    static let domain: ModuleDomain = .init(rawValue: 24)
    static let icon: UIImage? = nil

    static func make(forApp info: AppInfo) -> UIViewController {
        return UIViewController()
    }

    static func searchResults(for query: String) -> [SearchResult] {
        return []
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            try DebugKit.register(AppDebugModule.self)
            try DebugKit.register(PrivateModule.self)
        } catch {
            print(error)
        }
        return true
    }
}
