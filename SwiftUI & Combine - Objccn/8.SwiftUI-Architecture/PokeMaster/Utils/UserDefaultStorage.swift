//
//  UserDefaultStorage.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultStorage<T> {

    var value: T
    let key: String

    init(key: String, defaultValue: T) {
        self.key = key
        value = (UserDefaults.standard.value(forKey: key) as? T) ?? defaultValue
    }

    var wrappedValue: T {
        set {
            value = newValue
            UserDefaults.standard.set(newValue, forKey: key)
        }
        get { value }
    }
}
