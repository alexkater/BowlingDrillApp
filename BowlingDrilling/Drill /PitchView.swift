//
//  PitchView.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit

final class PitchView: NibDesignable {

    @IBOutlet weak var forwardTextfield: UITextField!
    @IBOutlet weak var backwardTextfield: UITextField!
    @IBOutlet weak var leftTextfield: UITextField!
    @IBOutlet weak var rightTextfield: UITextField!
    @IBOutlet weak var holeSizeTextfield: UITextField!
    @IBOutlet weak var holeSizeContainer: UIView!

    init() {
        super.init(frame: .zero)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
    }

}

// MARK: - Private
private extension PitchView {

    func setupViews() {
        holeSizeContainer.backgroundColor = .clear
        holeSizeContainer.layer.borderColor = UIColor.lightGray.cgColor
        holeSizeContainer.layer.borderWidth = 2
        holeSizeContainer.layer.cornerRadius = 45
    }

}
