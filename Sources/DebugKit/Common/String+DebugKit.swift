//
//  String+DebugKit.swift
//  DebugKit
//
//  Created by Aaron Sky on 8/19/18.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        if isEmpty {
            return true
        }
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
