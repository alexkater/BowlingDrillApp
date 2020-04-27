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
import GiphyUISDK
import GiphyCoreSDK

class DrillViewController: UIViewController {
    @IBOutlet weak var leftHolePitchView: PitchView!
    @IBOutlet weak var rightHolePitchView: PitchView!
    @IBOutlet weak var thumbHolePitchView: PitchView!
    @IBOutlet weak var righHandButton: UIButton!
    @IBOutlet weak var leftHandButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    private let mediaView = GPHMediaView()

    var user = MutableProperty<User?>(nil)
    private let firebaseService = stateManager.firebaseDatabase

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        scrollView.scrollRectToVisible(nameTextField.frame, animated: true)
        mediaView.contentMode = .scaleAspectFit
        self.addSubviewAndFillToSafeAnchors(mediaView)
        self.view.sendSubviewToBack(mediaView)
        self.view.backgroundColor = .black
        mediaView.setup()
    }

    @IBAction func exitAction(_ sender: Any) {
        saveUser()
        dismiss(animated: true, completion: nil)
    }

    static func instantiate() -> Self
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrillViewController") as! Self
    }
}

private extension DrillViewController {

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
        notesTextView.reactive.text <~ user.producer.skipNil().map { $0.notes }

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

    func saveUser() {
//        let firebaseReference = firebaseService.query(for: FirebaseRouter.users.path, keepSynced: true) as? DatabaseReference
//        guard let user = getUpdatedUser(), let dict = user.asDictionary() else { return }
//
//        firebaseReference?.child(user.id).setValue(dict)
    }
}
