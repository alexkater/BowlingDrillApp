//
//  ViewController.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 04/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit
import ReactiveSwift

class DrillingTableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var createNewUserButton: UIButton!

    var viewModel: DrillingTableViewModelProtocol = DrillingTableViewModel()

    private var cellViewModels: [DrillingCellViewModel] {
        return viewModel.cellViewModels.value
    }
    private var backgroundView: UIImageView = UIImageView(image: UIImage(named: "Background"))

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        setupBindings()
        navigationController?.navigationBar.barTintColor = .white
        title = "Welcome to Bowling Drilling"
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

        let controller = DrillViewController.instantiate(with: user)
        show(controller, sender: nil)
    }

    func setupBindings() {

        createNewUserButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            self?.showDrillViewController()
        }

        viewModel.cellViewModels.producer.startWithValues() { [weak self] _ in
            let indexSet = IndexSet(integer: 0)
            self?.tableView.reloadSections(indexSet, with: .automatic)
        }

        isLoading <~ viewModel.loading
        error <~ viewModel.error

        createNewUserButton.reactive.title <~ viewModel.addDrillButtonTitle
    }

    func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        tableView.backgroundView = backgroundView
        backgroundView.contentMode = .scaleAspectFit
    }
}
