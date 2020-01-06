//
//  ViewController.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 04/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GiphyUISDK
import GiphyCoreSDK

class TableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var createNewUserButton: UIButton!
    @IBOutlet weak var selectGifButton: UIButton!

    private let mediaView = GPHMediaView()

    var firebaseService = stateManager.firebaseDatabase
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                let indexSet = IndexSet(integer: 0)
                self?.tableView.reloadSections(indexSet, with: .automatic)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GiphyUISDK.configure(apiKey: "wlbQz6IczlcwIMg7ER3vxlvqwys9IVKN")

        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.reloadData()

        _ = firebaseService.observeObjects(query: firebaseService.query(for: FirebaseRouter.users.path)) { (users: [User]) in
            print("Users")
            print(users)
            self.users = users
        }

        mediaView.contentMode = .scaleAspectFit
        self.tableView.backgroundView = mediaView
        mediaView.setup()

        createNewUserButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            self?.showDrillViewController()
        }
        selectGifButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.mediaView.showViewController(from: strongSelf)
        }
    }
}

extension TableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.text = users[safe: indexPath.item]?.name
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = users[safe: indexPath.item] else {
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
            let firebaseReference = firebaseService.query(for: FirebaseRouter.users.path, keepSynced: true) as? DatabaseReference
            guard let user = users[safe: indexPath.item] else {
                       print("No user found for indexPath \(indexPath)")
                       return
                   }
            firebaseReference?.child(user.id).removeValue()
        }
    }
}

private extension TableViewController {

    func showDrillViewController(with user: User = .make()) {

        let controller = DrillViewController.instantiate()
        controller.user.value = user
        present(controller, animated: true, completion: nil)
    }
}
