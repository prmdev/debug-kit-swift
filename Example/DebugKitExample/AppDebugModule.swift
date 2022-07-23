//
//  AppDebugModule.swift
//  DebugKitExample
//
//  Created by prmdev on 8/19/18.
//

import UIKit
import DebugKit

struct AppDebugModule: DebugPresentable {
    static let name = "DebugKitExample"
    static let icon: UIImage? = nil

    static func createViewController() -> UIViewController {
        return AppDebugController()
    }

    static func searchResultsWithinModule(for query: String) -> [SearchResult] {
        return []
    }
}

class AppDebugController: UIViewController {

}
