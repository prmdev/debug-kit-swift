//
//  UIStackViewExtensions.swift
//  PDP
//
//  Created by Aaron Sky on 9/30/17.
//  Copyright © 2017 Aaron Sky. All rights reserved.
//

import UIKit

private func viewWithColor(_ color: UIColor, in frame: CGRect) -> UIView {
    let view = UIView(frame: frame)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = color
    return view
}

extension UIStackView {
    func addBackgroundColor(_ color: UIColor) {
        let view = viewWithColor(color, in: self.frame)
        self.addBackgroundView(view)
    }

    func addForegroundColor(_ color: UIColor) {
        let view = viewWithColor(color, in: self.frame)
        self.addForegroundView(view)
    }
}
