//
//  ReactiveSwift+AssociatedProperty.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import ReactiveSwift

// Lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(_ host: AnyObject, key: UnsafeRawPointer, factory: () -> T) -> T {
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return associatedProperty
    }()
}

func lazyMutableProperty<T>(_ host: AnyObject, key: UnsafeRawPointer, setter: @escaping (T) -> Void, getter: @escaping () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer.startWithValues { newValue in
            setter(newValue)
        }
        return property
    }
}

func lazyMutableProperty<T>(_ host: AnyObject,
                            key: UnsafeRawPointer,
                            skipRepeats: Bool = false,
                            setter: @escaping (T) -> Void,
                            getter: @escaping () -> T) -> MutableProperty<T> where T: Equatable {

    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())

        if skipRepeats {
            property.producer.skipRepeats().startWithValues { newValue in setter(newValue) }
        } else {
            property.producer.startWithValues { newValue in setter(newValue) }
        }

        return property
    }
}
