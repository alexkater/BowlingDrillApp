//
//  UIViewController+Loading.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import NVActivityIndicatorView

extension UIViewController {

private struct AssociatedKeys {
    static var isLoading = "isLoading"
    static var loadingSpinnerView = "loadingSpinnerView"
}

    var isLoading: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociatedKeys.isLoading, skipRepeats: true,
                                   setter: { [weak self] isLoading in self?.updateLoadingState(isLoading: isLoading) },
                                   getter: { false })
    }
}

extension UIViewController: NVActivityIndicatorViewable {

    func updateLoadingState(isLoading: Bool) {

         if isLoading {
             startAnimating()
         } else {
             stopAnimating()
         }
     }
}
