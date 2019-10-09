//
//  SecureStorageService.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 10/8/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import Locksmith

protocol SecureStorageServiceProvider {
    func saveToStorage(counter: Int)
    func updateInStorage(counter: Int)
    func loadFromStorage() -> Int
}

final public class SecureStorageService: SecureStorageServiceProvider {

    func saveToStorage(counter: Int) {
        do {
            try Locksmith.saveData(data: ["counter": counter], forUserAccount: "ShakeKeychain")
        } catch {
            print("Unable to save to keychain")
        }
    }

    func updateInStorage(counter: Int) {
        do {
            try Locksmith.updateData(data: ["counter": counter], forUserAccount: "ShakeKeychain")
        } catch {
            print("Unable to update in keychain")
        }
    }

    func loadFromStorage() -> Int {
        guard let counter = Locksmith.loadDataForUserAccount(userAccount: "ShakeKeychain")?["counter"] as? Int else {
            return 0
        }
        return counter
    }
}
