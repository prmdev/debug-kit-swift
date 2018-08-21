#if canImport(UIKit)
import UIKit
#endif

public protocol DebugPresentable {
    static var name: String { get }
    static var icon: UIImage? { get }
    static func createViewController() -> UIViewController
    static func searchResultsWithinModule(for query: String) -> [SearchResult]
}
