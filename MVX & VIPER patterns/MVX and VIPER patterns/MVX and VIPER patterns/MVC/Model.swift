//
//  Model.swift
//  MVX and VIPER patterns
//
//  Created by FicowShen on 2021/10/27.
//

import Foundation

fileprivate let TestURL = URL(string: "https://baidu.com")!

class MVCUserProfile {
    static let updateNameURL = TestURL

    let id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }

    func updateName(_ newName: String, completion: @escaping ((Error?) -> Void)) {
        URLSession(configuration: .default).dataTask(with: Self.updateNameURL) { [weak self] data, response, error in
            if error == nil {
                self?.name = newName
            }
            completion(error)
        }.resume()
    }
}


class TestableMVCUserProfile {
    static let updateNameURL = TestURL

    let id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }

    func updateName(_ newName: String,
                    taskMaker: DataTaskMaker, // 允许注入发起网络请求的对象
                    completion: @escaping ((Error?) -> Void)) {
        taskMaker.dataTask(with: Self.updateNameURL) { [weak self] data, response, error in
            if error == nil {
                self?.name = newName
            }
            completion(error)
        }
    }
}
