//
//  NibDesignable.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import UIKit

protocol NibDesignableType: NSObjectProtocol {
    var nibName: String { get }
    var nibContainerView: UIView { get }
}

extension NibDesignableType where Self: UIView {
    // MARK: - Nib loading

    /**
     Called to load the nib in setupNib().
     - returns: UIView instance loaded from a nib file.
     */

    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)

        guard
            let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        else { return UIView() }

        return view
    }

    /**
     Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
     */
    fileprivate func setupNib() {
        let view = loadNib()
        nibContainerView.addFillingSubview(view)
        nibContainerView.backgroundColor = .clear
    }
}

extension UIView: NibDesignableType {
    var nibContainerView: UIView { return self }
    var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last! // to remove the module name and get only file name
    }
}

/**

 # Usage of NibDesignable class
 It is added to be subclassed and to represent UIView in storyboard.
 Final outcome : Will add your nib designed to the container set in storybaord

 Make your custom UIView class to be subclassed of NibDesignable and design it as you want.
 Now make a xib (Same name) with UIView designed as you want, make your custom class to be file owner of this nib,
 so that outlet can be linked.
 When you want to use this in your storyboard, add view there with all constraint you want
 and set your custom class to be class in side inspector.
 */

/// This class only exists in order to be subclassed.
class NibDesignable: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
}

/// This class only exists in order to be subclassed.
class ControlNibDesignable: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
}
