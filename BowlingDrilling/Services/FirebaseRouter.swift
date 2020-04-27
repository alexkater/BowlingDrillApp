//
//  FirebaseRouter.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import UIKit

enum FirebaseRouter: Hashable {
    case users
    case user(userId: String)

    var currentDevice: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    var path: String {
        switch self {
        case .users:
            return "/\(currentDevice)/users"
        case .user(let userId):
            return "/\(currentDevice)/users/\(userId)"
        }
    }
}
