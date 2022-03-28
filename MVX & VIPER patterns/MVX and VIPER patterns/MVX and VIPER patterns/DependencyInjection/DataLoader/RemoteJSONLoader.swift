//
//  RemoteJSONLoader.swift
//  MVX and VIPER patterns
//
//  Created by Ficow on 2022/3/27.
//

import Foundation

protocol RemoteJSONLoader: AnyObject {
    func loadRequest<T>(_ request: URLRequest, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable
}

final class DefaultRemoteJSONLoader: RemoteJSONLoader {
    private let session = URLSession.shared

    func loadRequest<T>(
        _ request: URLRequest,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) where T: Decodable {
        session
            .dataTask(with: request) { data, response, error in
                guard let data = data else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        let res = response as? HTTPURLResponse
                        let error = NSError(
                            domain: "com.ficowshen.blog",
                            code: res?.statusCode ?? -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: res?.url?.description ?? "invalid url"
                            ])
                        completion(.failure(error))
                    }
                    return
                }
                do {
                    let t = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(t))
                } catch {
                    completion(.failure(error))
                }
            }
            .resume()
    }
}
