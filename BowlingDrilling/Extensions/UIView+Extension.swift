//
//  UIView+Extension.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit

extension UIViewController {

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return topLayoutGuide.bottomAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomLayoutGuide.topAnchor
        }
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.trailingAnchor
        } else {
            return view.trailingAnchor
        }
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.leadingAnchor
        } else {
            return view.leadingAnchor
        }
    }

    /// Adds a subview to it's view, fill's it and attach it to the View Controller's safe areas
    ///
    /// - Parameter subview: subview to be added
    func addSubviewAndFillToSafeAnchors(_ subview: UIView,
                                        topMargin: CGFloat = 0,
                                        bottomMargin: CGFloat = 0,
                                        leadingMargin: CGFloat = 0,
                                        trailingMargin: CGFloat = 0) {
        view.addSubview(subview)
        constraintViewToSafeAnchors(view: subview,
                                    topMargin: topMargin,
                                    bottomMargin: bottomMargin,
                                    leadingMargin: leadingMargin,
                                    trailingMargin: trailingMargin)
    }

    /// Attach view's anchors to View Controller's safe areas
    ///
    /// - Parameter view: the view to attach
    func constraintViewToSafeAnchors(view: UIView,
                                     topMargin: CGFloat = 0,
                                     bottomMargin: CGFloat = 0,
                                     leadingMargin: CGFloat = 0,
                                     trailingMargin: CGFloat = 0) {
        view.anchor(top: safeTopAnchor, topMargin: topMargin,
                    bottom: safeBottomAnchor, bottomMargin: bottomMargin,
                    leading: safeLeadingAnchor, leadingMargin: leadingMargin,
                    trailing: safeTrailingAnchor, trailingMargin: trailingMargin)
    }
}
