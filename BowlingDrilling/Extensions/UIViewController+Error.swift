//
//  UIViewController+Error.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import ReactiveSwift

var viewControllerErrorKey = "viewControllerError"

extension UIViewController {

    func showError(title: String = "Oooops!",
                   message: String?,
                   dismissTitle: String = "Ok",
                   completion: (() -> Void)? = nil) {

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: dismissTitle, style: .default, handler: { _ in completion?() }))

        present(controller, animated: true)
    }

    /// Allows you to bind to a view model's error property so the view controller can show the error message to the user
    var error: MutableProperty<String?> {
        return lazyMutableProperty(
            self,
            key: &viewControllerErrorKey,
            setter: { [weak self] message in
                guard let strongSelf = self, let message = message else { return }
                strongSelf.showError(message: message)
            },
            getter: {
                return .none
        })
    }
}
