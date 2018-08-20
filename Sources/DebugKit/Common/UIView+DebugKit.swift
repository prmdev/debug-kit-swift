//
//  UIViewExtensions.swift
//  PDP
//
//  Created by Aaron Sky on 9/28/17.
//  Copyright © 2017 Aaron Sky. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    func isVisibleInSuperview() -> Bool {
        guard let superview = self.superview else {
            return false
        }
        return self.isVisible(inside: superview)
    }

    func isVisible(inside view: UIView, completely: Bool = false) -> Bool {
        if self.isHidden {
            return false
        } else if self.superview == nil {
            return false
        } else if self.alpha <= 0.0 {
            return false
        } else if view.bounds.intersects(self.frame) {
            if completely {
                return view.bounds.contains(self.frame)
            }
            return true
        }
        return false
    }

    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func unpin(from view: UIView) {
        NSLayoutConstraint.deactivate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    func traverseSuperviews(_ until: (UIView) throws -> Bool) rethrows -> UIView? {
        var pointer: UIView? = self
        while pointer?.superview != nil {
            guard let view = pointer else {
                return nil
            }
            if try until(view) {
                return view
            }
            pointer = view.superview
        }
        return nil
    }

    func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    func addBackgroundView(_ view: UIView) {
        self.insertSubview(view, at: 0)
        view.pin(to: self)
    }

    func addForegroundView(_ view: UIView) {
        self.addSubview(view)
        view.pin(to: self)
    }

    // Workaround for the UIStackView bug where setting hidden to true with animation
    // mulptiple times requires setting hidden to false multiple times to show the view.
    func workaround_nonRepeatingSetHidden(hidden: Bool) {
        if self.isHidden != hidden {
            self.isHidden = hidden
        }
    }
}
