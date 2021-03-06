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
    @IBOutlet weak var cutSpanTextField: UITextField!
    @IBOutlet weak var spanTextField: UITextField!

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

    func setup(with hole: Hole, isFingerHole: Bool) {
        forwardTextfield.text = hole.forwardPitch
        backwardTextfield.text = hole.backwardPitch
        leftTextfield.text = hole.leftPitch
        rightTextfield.text = hole.rightPitch
        holeSizeTextfield.text = hole.holeSize
        cutSpanTextField.text = hole.cutSpan
        spanTextField.text = hole.span
        cutSpanTextField.isHidden = !isFingerHole
        spanTextField.isHidden = !isFingerHole
    }

    func getHoleValues() -> Hole {
        return Hole(forwardPitch: forwardTextfield.text ?? "0",
                    backwardPitch: backwardTextfield.text ?? "0",
                    leftPitch: leftTextfield.text ?? "0",
                    rightPitch: rightTextfield.text ?? "0",
                    holeSize: holeSizeTextfield.text ?? "0",
                    cutSpan: cutSpanTextField.text ?? "0",
                    span: spanTextField.text ?? "0")
    }
}

// MARK: - Private
private extension PitchView {

    func setupViews() {
        holeSizeContainer.backgroundColor = UIColor(named: "BackgroundColor")
        holeSizeContainer.layer.borderColor = UIColor.lightGray.cgColor
        holeSizeContainer.layer.borderWidth = 2
        holeSizeContainer.layer.cornerRadius = 45
    }
}
