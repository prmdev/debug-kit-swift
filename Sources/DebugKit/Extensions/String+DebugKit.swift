//
//  String+DebugKit.swift
//  DebugKit
//
//  Created by Aaron Sky on 8/19/18.
//

import Foundation

extension String {
    /**
     Helper property to surface whether a string is visibly empty,
     i.e. is either empty or is only whitespace characters.
     */
    var isEmptyOrWhitespace: Bool {
        if isEmpty {
            return true
        }
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
