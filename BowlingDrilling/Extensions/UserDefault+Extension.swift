//
//  UserDefault+Extension.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

extension UserDefaults {

    private static var mediaIdKey: String { return "MediaIDKey"}

    static func save(mediaId id: String) {
        UserDefaults.standard.set(id, forKey: Self.mediaIdKey)
    }

    static var mediaId: String {
        return UserDefaults.standard.string(forKey: mediaIdKey) ?? "l46CxnIvqj8BiLZLy"
    }
}
