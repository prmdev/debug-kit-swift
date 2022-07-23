//
//  SearchResult.swift
//  DebugKit
//
//  Created by prmdev on 8/21/18.
//

public struct SearchResult {
    public let match: String
    public let path: [String]
    internal var type: DebugPresentable.Type?

    public init(match: String, path: [String]) {
        self.init(match: match, path: path, type: nil)
    }

    internal init(match: String, path: [String], type: DebugPresentable.Type?) {
        self.match = match
        self.path = path
        self.type = type
    }

    internal var renderedPath: String {
        return path.joined(separator: " → ")
    }
}
