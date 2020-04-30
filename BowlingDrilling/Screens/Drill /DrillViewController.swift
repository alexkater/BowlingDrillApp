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
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    var viewModel: DrillViewModelProtocol!

    private lazy var backButton = UIBarButtonItem(title: "Back", style: .plain,
                                                  target: self, action: #selector(backButtonTapped))
    private lazy var saveButton = UIBarButtonItem(title: "Save", style: .plain,
                                                  target: self, action: #selector(saveButtonTapped))
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        scrollView.scrollRectToVisible(nameTextField.frame, animated: true)
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = saveButton
    }

    @objc func saveButtonTapped() {
        saveUser()
    }

    @objc func backButtonTapped() {
        saveUser(true)
    }

    static func instantiate(with user: User) -> Self
    {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrillViewController") as! Self
        controller.viewModel = DrillViewModel(user: user)
        return controller
    }
}

private extension DrillViewController {

    func setupBindings() {
        leftHolePitchView.reactive.viewModel <~ viewModel.leftHole.producer.skipNil()
        rightHolePitchView.reactive.viewModel <~ viewModel.rightHole.producer.skipNil()
        thumbHolePitchView.reactive.viewModel <~ viewModel.thumbHole.producer.skipNil()

        righHandButton.reactive.isSelected <~ viewModel.hand.map { $0.isRightHanded }
        leftHandButton.reactive.isSelected <~ viewModel.hand.map { !$0.isRightHanded }
        nameTextField.reactive.text <~ viewModel.name
        notesTextView.reactive.text <~ viewModel.notes

        righHandButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            self?.righHandButton.isSelected = true
            self?.leftHandButton.isSelected = false
        }

        leftHandButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            self?.leftHandButton.isSelected = true
            self?.righHandButton.isSelected = false
        }

        backButton.reactive.title <~ viewModel.title
        saveButton.reactive.title <~ viewModel.saveButtonTitle

        isLoading <~ viewModel.loading
        error <~ viewModel.error

        viewModel.saveAction.values.observeValues { [weak self] (haveToPop) in
            if haveToPop { self?.navigationController?.popViewController(animated: true) }
        }
    }

    func saveUser(_ haveToDissmiss: Bool = false) {
        viewModel.saveAction.apply(haveToDissmiss).start()
    }
}
