//
//  LocalCacheLoader.swift
//  MVX and VIPER patterns
//
//  Created by Ficow on 2022/3/27.
//

import Foundation

enum CacheAccessError: Error {
    case noCachedData
}

protocol LocalCacheManaging: AnyObject {
    func readCache<T>(key: String, type: T.Type) throws -> T where T : Decodable
    func writeCache<T>(key: String, model: T) throws where T : Encodable
}

final class UserDefaultsLocalCacheManager: LocalCacheManaging {

    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func readCache<T>(key: String, type: T.Type) throws -> T where T: Decodable {
        guard let data = userDefaults.data(forKey: key) else {
            throw CacheAccessError.noCachedData
        }
        return try decoder.decode(type, from: data)
    }

    func writeCache<T>(key: String, model: T) throws where T: Encodable {
        let data = try encoder.encode(model)
        userDefaults.set(data, forKey: key)
    }
}
