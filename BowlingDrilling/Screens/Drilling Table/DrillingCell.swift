//
//  DrillingCell.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import UIKit

class DrillingCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handLabel: UILabel!

    func setup(viewModel: DrillingCellViewModel) {
        nameLabel.text = viewModel.name
        handLabel.text = viewModel.hand
    }
}
