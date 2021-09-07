//
//  ViewController.swift
//  AsyncAwaitDemo
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataWithCompletionHandler()
        loadDataWithCoroutine()
    }

    enum FetchError: Error {
        case invalidResponse
        case invalidData
        case badRequest
    }

    func loadDataWithCompletionHandler() {
        let url = URL(string: "https://www.apple.com")!
        fetch(url: url) { result in
            switch result {
            case let .success((data, response)):
                log(data, response)
            case .failure(let error):
                log(error)
            }
        }
    }

    func fetch(url: URL, completionHandler: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            switch (data, response) {
            case let (data?, response?):
                completionHandler(.success((data, response)))
            case (_?, nil):
                completionHandler(.failure(FetchError.invalidResponse))
            case (nil, _?):
                completionHandler(.failure(FetchError.invalidData))
            case (nil, nil):
                completionHandler(.failure(FetchError.badRequest))
            }
        }.resume()
    }

    func loadDataWithCoroutine() {
        async {
            let url = URL(string: "https://www.apple.com")!
            do {
                let (data, resonse) = try await fetch(url: url)
                log(data, resonse)
            } catch {
                log(error)
            }
        }
    }

    func fetch(url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(for: URLRequest(url: url))
    }
}

func log(_ items: Any..., function: String = #function) {
    print(function, items)
}

