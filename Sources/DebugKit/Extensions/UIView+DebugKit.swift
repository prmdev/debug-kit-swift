//
//  UIViewExtensions.swift
//  PDP
//
//  Created by prmdev on 9/28/17.
//  Copyright © 2017 prmdev. All rights reserved.
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

    /**
     Helper to determine whether a view is visible within its superview.
     
     Returns `false` if the view does not have a superview.
     */
    func isVisibleInSuperview() -> Bool {
        guard let superview = self.superview else {
            return false
        }
        return self.isVisible(inside: superview)
    }

    /**
     Helper to determine whether a view is visible within another view.
     */
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

    /**
     Helper to add constraints from this view to the passed view's anchors.
     */
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /**
     Helper to remove constraints from this view to the passed view's anchors.
     */
    func unpin(from view: UIView) {
        NSLayoutConstraint.deactivate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    /**
     Crawls the view hierarchy searching for a view until a match is found,
     then it returns the found view.
     - Parameter until: Predicate closure that confirms a matching view
     - Parameter view: The view to be inspected for matching
     - Returns: An `Optional` containing the matched view, or `nil`
     */
    func traverseSuperviews(_ until: (_ view: UIView) throws -> Bool) rethrows -> UIView? {
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

    /**
     Helper to remove all subviews from the view hierarchy.
     */
    func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    /**
     Helper to add a view to the back of the view hierarchy.
     
     The newly added view is automatically pinned to the anchors of the view.
     - Parameter view: The view to add
     */
    func addBackgroundView(_ view: UIView) {
        self.insertSubview(view, at: 0)
        view.pin(to: self)
    }

    /**
     Helper to add a view to the front of the view hierarchy.
     
     The newly added view is automatically pinned to the anchors of the view.
     - Parameter view: The view to add
     */
    func addForegroundView(_ view: UIView) {
        self.addSubview(view)
        view.pin(to: self)
    }
}
