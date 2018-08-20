//
//  AppDebugModule.swift
//  DebugKitExample
//
//  Created by Aaron Sky on 8/19/18.
//

import UIKit
import DebugKit

struct AppDebugModule: DebugModule {
    static let name = "DebugKitExample"
    static let domain: ModuleDomain = .app
    static let icon: UIImage? = nil

    static func make(forApp info: AppInfo) -> UIViewController {
        return AppDebugController()
    }

    static func searchResults(for query: String) -> [SearchResult] {
        return []
    }
}

class AppDebugController: UIViewController {

}
