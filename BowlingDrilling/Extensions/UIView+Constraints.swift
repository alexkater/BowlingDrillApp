//
//  UIView+Constraints.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit

extension UIView {

    /// The first available width constraint for this view.
    var widthConstraint: NSLayoutConstraint? {
        return constraints.first { $0.firstAttribute == .width && $0.secondItem == nil }
    }

    /// The first available height constraint for this view.
    var heightConstraint: NSLayoutConstraint? {
        return constraints.first { $0.firstAttribute == .height && $0.secondItem == nil }
    }

    func searchConstraint(_ identifier: String) -> NSLayoutConstraint? {
        for constraint in constraints where (constraint.identifier == identifier) {
            return constraint
        }
        return nil
    }

    /// Adds a array of subviews to self
    ///
    /// - Parameter subviews: the array of subviews to be added
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }

    /// Adds a subview to self and sets it's translatesAutoresizingMaskIntoConstraints property to false
    ///
    /// - Parameter subview: the subview to be added
    func addSubviewForAutoLayout(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }

    /// Adds a array of subviews to self and sets their translatesAutoresizingMaskIntoConstraints property to false
    ///
    /// - Parameter subviews: the array of subviews to be added
    func addSubviewsForAutoLayout(_ subviews: [UIView]) {
        subviews.forEach { subview in
            addSubviewForAutoLayout(subview)
        }
    }

    /// Adds a subview to self with constraints to fill it
    ///
    /// - Parameters:
    ///   - subview: the view to be added
    ///   - margin: an optional margin for all sides on the subview
    func addFillingSubview(_ subview: UIView, margin: CGFloat = 0) {
        addSubview(subview)
        subview.fillToSuperview(margin: margin)
    }

    /// Adds a subview to self with constraints to center it
    ///
    /// - Parameter subview: the view to be added
    func addCenteredSubview(_ subview: UIView) {
        addSubview(subview)
        subview.centerToSuperview()
    }

    /// Fills self to it's superview by adding anchors
    ///
    /// - Parameter margin: an optional margin (in positive value)
    func fillToSuperview(margin: CGFloat = 0) {
        guard let superview = superview else {
            fatalError("\(self) does not have a superview")
        }
        anchor(top: superview.topAnchor, topMargin: margin,
               bottom: superview.bottomAnchor, bottomMargin: margin,
               leading: superview.leadingAnchor, leadingMargin: margin,
               trailing: superview.trailingAnchor, trailingMargin: margin)
    }

    /// Centers self to it's superview by adding anchors
    func centerToSuperview() {
        guard let superview = superview else {
            fatalError("\(self) does not have a superview")
        }
        anchor(centerX: superview.centerXAnchor,
               centerY: superview.centerYAnchor)
    }

    /// Method to add anchors easier
    /// Note: anchors will be activated by default and the view will have it's translatesAutoresizingMaskIntoConstraints
    /// property set to false
    ///
    /// - Parameters:
    ///   - top: NSLayoutYAxisAnchor to be attached to self.topAnchor
    ///   - topMargin: top margin separation (positive value)
    ///   - bottom: NSLayoutYAxisAnchor to be attached to self.bottomAnchor
    ///   - bottomMargin: bottom margin separation (positive value)
    ///   - left: NSLayoutXAxisAnchor to be attached to self.leftAnchor
    ///   - leftMargin: left margin separation (positive value)
    ///   - leading: NSLayoutXAxisAnchor to be attached to self.leadingAnchor
    ///   - leadingMargin: leading margin separation (positive value)
    ///   - right: NSLayoutXAxisAnchor to be attached to self.rightAnchor
    ///   - rightMargin: right margin separation (positive value)
    ///   - trailing: NSLayoutXAxisAnchor to be attached to self.trailingAnchor
    ///   - trailingMargin: trailing margin separation (positive value)
    ///   - centerX: NSLayoutXAxisAnchor to be attached to self.centerXAnchor
    ///   - centerY: NSLayoutYAxisAnchor to be attached to self.centerYAnchor
    ///   - widthConstant: a width constant for self.widthAnchor
    ///   - heightConstant: a height constant for self.heightAnchor
    /// - Returns: An array with all constraints already activated
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                topMargin: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,
                bottomMargin: CGFloat = 0,
                left: NSLayoutXAxisAnchor? = nil,
                leftMargin: CGFloat = 0,
                leading: NSLayoutXAxisAnchor? = nil,
                leadingMargin: CGFloat = 0,
                right: NSLayoutXAxisAnchor? = nil,
                rightMargin: CGFloat = 0,
                trailing: NSLayoutXAxisAnchor? = nil,
                trailingMargin: CGFloat = 0,
                centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                widthConstant: CGFloat = 0,
                heightConstant: CGFloat = 0,
                priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {

        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topMargin))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomMargin))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftMargin))
        }
        if let leading = leading {
            anchors.append(leadingAnchor.constraint(equalTo: leading, constant: leadingMargin))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightMargin))
        }
        if let trailing = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingMargin))
        }
        if let centerX = centerX {
            anchors.append(centerXAnchor.constraint(equalTo: centerX))
        }
        if let centerY = centerY {
            anchors.append(centerYAnchor.constraint(equalTo: centerY))
        }
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        if let priority = priority {
            anchors.forEach { $0.priority = priority }
        }
        NSLayoutConstraint.activate(anchors)
        return anchors
    }
}
