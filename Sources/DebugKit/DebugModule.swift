#if canImport(UIKit)
import UIKit
#endif

public protocol DebugModule {
    static var name: String { get }
    static var domain: ModuleDomain { get }
    static var icon: UIImage? { get }
    static func make(forApp info: AppInfo) -> UIViewController
    static func searchResults(for query: String) -> [SearchResult]
}

public struct ModuleDomain: Hashable, OptionSet, Comparable {
    public let rawValue: UInt8

    public static let app = ModuleDomain(rawValue: 1 << 0)
    public static let core = ModuleDomain(rawValue: 1 << 2)
    public static let user = ModuleDomain(rawValue: 1 << 3)
    public static let media = ModuleDomain(rawValue: 1 << 4)

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static func < (lhs: ModuleDomain, rhs: ModuleDomain) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public struct SearchResult {
    public let match: String
    public let path: [String]
    internal var type: DebugModule.Type?

    public init(match: String, path: [String]) {
        self.init(match: match, path: path, type: nil)
    }

    internal init(match: String, path: [String], type: DebugModule.Type?) {
        self.match = match
        self.path = path
        self.type = type
    }

    internal var renderedPath: String {
        return path.joined(separator: " → ")
    }
}
