//
//  UserInfo.swift
//  MVX and VIPER patterns
//
//  Created by Ficow on 2022/3/27.
//

import Foundation

protocol DIUserInfoLoaderConvertible: AnyObject {
    func loadUserInfo(completion: @escaping (Result<DIUser, Error>) -> Void)
}

final class DIUserInfoLoader: DIUserInfoLoaderConvertible {

    private let remoteJSONLoader: RemoteJSONLoader
    private let localCacheManager: LocalCacheManaging

    private let userInfoCacheKey = "DIUserInfoLoader.userInfoCacheKey"
    private let userInfoRequest: URLRequest = {
        // Great! We can use this free tool to save our JSON online easily:
        // https://www.npoint.io/docs/e0ce0dc1024c69a5e6b0
        // Thanks the author!
        var request = URLRequest(url: URL(string: "https://api.npoint.io/e0ce0dc1024c69a5e6b0")!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }()

    init(
        localCacheManager: LocalCacheManaging = UserDefaultsLocalCacheManager(),
        remoteJSONLoader: RemoteJSONLoader = DefaultRemoteJSONLoader()
    ) {
        self.localCacheManager = localCacheManager
        self.remoteJSONLoader = remoteJSONLoader
    }

    func loadUserInfo(completion: @escaping (Result<DIUser, Error>) -> Void) {
        do {
            let userInfo = try localCacheManager.readCache(key: userInfoCacheKey, type: DIUser.self)
            completion(.success(userInfo))
        } catch {
            remoteJSONLoader.loadRequest(userInfoRequest, type: DIUser.self) { [weak self] result in
                if case .success(let user) = result {
                    self?.cacheUser(user)
                }
                completion(result)
            }
        }
    }

    private func cacheUser(_ user: DIUser) {
        do {
            try localCacheManager.writeCache(key: userInfoCacheKey, model: user)
        } catch {
            print("cache user failed, error:", error)
        }
    }
}

struct DIUser: Codable {
    let id: String
    let name: String
    let gender: String
}
