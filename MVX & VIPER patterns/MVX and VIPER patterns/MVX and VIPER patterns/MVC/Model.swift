//
//  Model.swift
//  MVX and VIPER patterns
//
//  Created by FicowShen on 2021/10/27.
//

import Foundation

struct MVCUserProfile {
    static let updateNameURL = URL(string: "...")!

    let id: UUID
    let name: String

    mutating func updateName(_ newName: String, completion: @escaping ((Error?) -> Void)) {
        URLSession(configuration: .default).dataTask(with: Self.updateNameURL) { data, response, error in
            completion(error)
        }
    }
}
