//
//  GiphyExtensions.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import GiphyUISDK
import GiphyCoreSDK

extension GPHMediaView {

    /// Setup with last mediaIdSaved
    func setup() {
        GiphyCore.shared.gifByID(UserDefaults.mediaId) { (response, error) in
            if let media = response?.data {
                DispatchQueue.main.sync { [weak self] in
                    self?.setMedia(media)
                }
            }
        }
    }

    func showViewController(from viewController: UIViewController) {
        let giphyController = GiphyViewController()
        giphyController.mediaTypeConfig = [.gifs]
        viewController.present(giphyController, animated: true, completion: { [weak self] in
            self?.giphyController = giphyController
            self?.giphyController?.delegate = self
        })
    }
}

private var kGiphyControllerKey: UInt8 = 0

extension GPHMediaView: GiphyDelegate {

    var giphyController: GiphyViewController? {
        get {
            return objc_getAssociatedObject(self, &kGiphyControllerKey) as? GiphyViewController
        }
        set {
            objc_setAssociatedObject(self, &kGiphyControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func didDismiss(controller: GiphyViewController?) {
        giphyController = nil
    }

    public func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        self.setMedia(media)
        UserDefaults.save(mediaId: media.id)
        giphyController?.dismiss(animated: true, completion: { [weak self] in
            self?.giphyController = nil
        })
   }
}
