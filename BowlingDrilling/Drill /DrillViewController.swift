//
//  DrillViewController.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import FirebaseDatabase

class DrillViewController: UIViewController {
    @IBOutlet weak var leftHolePitchView: PitchView!
    @IBOutlet weak var rightHolePitchView: PitchView!
    @IBOutlet weak var thumbHolePitchView: PitchView!
    @IBOutlet weak var righHandButton: UIButton!
    @IBOutlet weak var leftHandButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var containerView: UIView!

    var user = MutableProperty<User?>(nil)
    private let firebaseService = stateManager.firebaseDatabase

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.createLines()
        }
    }

    static func instantiate() -> Self
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrillViewController") as! Self
    }
}

extension UIView {

    func addLineBetween(startPoint: CGPoint, endPoint: CGPoint) {
        // create path

        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)

        // Create a `CAShapeLayer` that uses that `UIBezierPath`:

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2

        // Add that `CAShapeLayer` to your view's layer:
        layer.addSublayer(shapeLayer)
    }
}

private extension DrillViewController {

    func createLines() {
        let leftHoleCenter = leftHolePitchView.convert(leftHolePitchView.holeSizeContainer.center, to: view)
        let rightHoleCenter = rightHolePitchView.convert(rightHolePitchView.holeSizeContainer.center, to: view)
        let thumbCenter = thumbHolePitchView.convert(thumbHolePitchView.holeSizeContainer.center, to: view)

        containerView.addLineBetween(startPoint: leftHoleCenter, endPoint: thumbCenter)
        containerView.addLineBetween(startPoint: rightHoleCenter, endPoint: thumbCenter)
    }

    func setupBindings() {
        user.producer.skipNil()
            .observe(on: UIScheduler())
            .startWithValues { [weak self] (user) in
            self?.leftHolePitchView.setup(with: user.leftHole, isFingerHole: true)
            self?.rightHolePitchView.setup(with: user.rightHole, isFingerHole: true)
            self?.thumbHolePitchView.setup(with: user.thumbHole, isFingerHole: false)
        }

        righHandButton.reactive.isSelected <~ user.producer.skipNil().map({ $0.hand.isRightHanded })
        leftHandButton.reactive.isSelected <~ user.producer.skipNil().map({ !$0.hand.isRightHanded })
        nameTextField.reactive.text <~ user.producer.skipNil().map { $0.name }

        saveButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            let firebaseReference = self?.firebaseService.query(for: FirebaseRouter.users.path, keepSynced: true) as? DatabaseReference
            guard let user = self?.getUpdatedUser(), let dict = user.asDictionary() else { return }

            firebaseReference?.child(user.id).setValue(dict)
        }

        righHandButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            self?.righHandButton.isSelected = true
            self?.leftHandButton.isSelected = false
        }

        leftHandButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            self?.leftHandButton.isSelected = true
            self?.righHandButton.isSelected = false
        }
    }

    func getUpdatedUser() -> User? {
        var savedUser = user.value
        savedUser?.leftHole = leftHolePitchView.getHoleValues()
        savedUser?.rightHole = rightHolePitchView.getHoleValues()
        savedUser?.thumbHole = thumbHolePitchView.getHoleValues()
        savedUser?.hand = righHandButton.isSelected ? .right : .left
        savedUser?.name = nameTextField.text ?? "No Name yet! \(Date().description)"
        savedUser?.notes = notesTextView.text
        return savedUser
    }
}
