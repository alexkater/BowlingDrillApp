//
//  ViewController.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 04/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit
import ReactiveSwift
import GiphyUISDK
import GiphyCoreSDK

class DrillingTableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var createNewUserButton: UIButton!
    @IBOutlet weak var selectGifButton: UIButton!

    private let mediaView = GPHMediaView()
    var viewModel: DrillingTableViewModelProtocol = DrillingTableViewModel()

    private var cellViewModels: [DrillingCellViewModel] {
        return viewModel.cellViewModels.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureGIF()
        configureTableView()
        setupBindings()
    }
}

extension DrillingTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DrillingCell.self), for: indexPath) as? DrillingCell else {
            return UITableViewCell()
        }
        cell.setup(viewModel: cellViewModels[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = cellViewModels[safe: indexPath.item]?.user else {
            print("No user found for indexPath \(indexPath)")
            return
        }
        showDrillViewController(with: user)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteUser(with: indexPath.row)
        }
    }
}

private extension DrillingTableViewController {

    func showDrillViewController(with user: User = .make()) {

        let controller = DrillViewController.instantiate()
        controller.user.value = user
//        present(controller, animated: true, completion: nil)
        show(controller, sender: nil)
    }

    func setupBindings() {

        createNewUserButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            self?.showDrillViewController()
        }
        selectGifButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.mediaView.showViewController(from: strongSelf)
        }

        viewModel.cellViewModels.producer.startWithValues() { [weak self] _ in
            let indexSet = IndexSet(integer: 0)
            self?.tableView.reloadSections(indexSet, with: .automatic)
        }

        isLoading <~ viewModel.loading
        error <~ viewModel.error

        selectGifButton.reactive.title <~ viewModel.changeBackgroundButtonTitle
        createNewUserButton.reactive.title <~ viewModel.addDrillButtonTitle
    }

    func configureGIF() {
        mediaView.contentMode = .scaleAspectFit
        self.tableView.backgroundView = mediaView
        mediaView.setup()
    }

    func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
}
