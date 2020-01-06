//
//  Array+Extension.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

extension Array {

/// Accesses the element at the specified position or returns `nil` if `index` is out of bounds.
subscript(safe index: Int) -> Element? {
    return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
