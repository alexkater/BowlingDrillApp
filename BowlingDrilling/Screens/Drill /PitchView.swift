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

    private let dispose = SerialDisposable()

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

    func getHoleValues() -> Hole {
        return Hole(forwardPitch: forwardTextfield.text ?? "0",
                    backwardPitch: backwardTextfield.text ?? "0",
                    leftPitch: leftTextfield.text ?? "0",
                    rightPitch: rightTextfield.text ?? "0",
                    holeSize: holeSizeTextfield.text ?? "0",
                    cutSpan: cutSpanTextField.text ?? "0",
                    span: spanTextField.text ?? "0")
    }

    func setup(viewModel hole: HoleViewModel) {
        forwardTextfield.text = hole.forwardPitch.value
        backwardTextfield.text = hole.backwardPitch.value
        leftTextfield.text = hole.leftPitch.value
        rightTextfield.text = hole.rightPitch.value
        holeSizeTextfield.text = hole.holeSize.value
        cutSpanTextField.text = hole.cutSpan.value
        spanTextField.text = hole.span.value

        cutSpanTextField.isHidden = !hole.isFingerHole
        spanTextField.isHidden = !hole.isFingerHole

        let disposeBag = CompositeDisposable()
        dispose.inner = disposeBag

        disposeBag += hole.forwardPitch <~ forwardTextfield.reactive.continuousTextValues
        disposeBag += hole.backwardPitch <~ backwardTextfield.reactive.continuousTextValues
        disposeBag += hole.leftPitch <~ leftTextfield.reactive.continuousTextValues
        disposeBag += hole.rightPitch <~ rightTextfield.reactive.continuousTextValues
        disposeBag += hole.holeSize <~ holeSizeTextfield.reactive.continuousTextValues
        disposeBag += hole.cutSpan <~ cutSpanTextField.reactive.continuousTextValues
        disposeBag += hole.span <~ spanTextField.reactive.continuousTextValues
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

import ReactiveSwift
import ReactiveCocoa

//typealias HoleViewModel = (hole: Hole, isFingerHole: Bool)

extension Reactive where Base: PitchView {

    var viewModel: BindingTarget<HoleViewModel> {
        return makeBindingTarget { base, hole  in
            base.setup(viewModel: hole)
        }
    }
}
