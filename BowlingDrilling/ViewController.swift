//
//  ViewController.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 04/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
}

extension TableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.textLabel?.text = "Test"
        cell.detailTextLabel?.text = "Description text"

        return cell
    }
}
