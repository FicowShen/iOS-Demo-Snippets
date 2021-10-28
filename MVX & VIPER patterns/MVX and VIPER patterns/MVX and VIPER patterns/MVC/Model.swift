//
//  Model.swift
//  MVX and VIPER patterns
//
//  Created by FicowShen on 2021/10/27.
//

import Foundation

class MVCUserProfile {
    static let updateNameURL = URL(string: "...")!

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


protocol DataTaskMaker: AnyObject {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

// 让 URLSession 实现协议，便于注入
extension URLSession: DataTaskMaker {}

class TestableMVCUserProfile {
    static let updateNameURL = URL(string: "...")!

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
        }.resume()
    }
}
