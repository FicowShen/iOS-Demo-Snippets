//
//  main.swift
//  GenericDemo
//
//  Created by FicowShen on 2021/9/24.
//

import Foundation

print("Hello, World!")

enum MaxFunctions {
    func max(_ a: Int, _ b: Int) -> Int {
        return a > b ? a : b
    }
    func max(_ a: Float, _ b: Float) -> Float {
        return a > b ? a : b
    }
    func max(_ a: String, _ b: String) -> String {
        return a > b ? a : b
    }
    func max<T>(_ x: T, _ y: T) -> T where T : Comparable {
        return x > y ? x : y
    }
}

class A: Comparable {
    static func == (lhs: A, rhs: A) -> Bool {
        return lhs === rhs
    }

    static func < (lhs: A, rhs: A) -> Bool {
        return false
    }
}

print(max(1, 1))
print(max(1.0, 1.0))
print(max("a", "b"))

Array<Int>([1, 2])

enum BinaryTree<Element> {
    case leaf
    indirect case node(Element,
                       l: BinaryTree<Element>,
                       r: BinaryTree<Element>)
}

extension BinaryTree {
    init(_ value: Element) {
        self = .node(value, l: .leaf, r: .leaf)
    }
}

extension BinaryTree {
    var values: [Element] {
        switch self {
        case .leaf:
            return []
        case let .node(el, left, right):
            return left.values + [el] + right.values
        }
    }
}

//extension Array {
//    func reduce<Result>(_ initial: Result, _ combine: (Result, Element) -> Result) -> Result
//}

struct User: Decodable {}

enum NetworkError: Error {
    case noData
}

let webserviceURL = URL(string: "https://ficowshen.com")!

extension URLSession {
    func loadUser(callback: @escaping (Result<User, Error>) -> ()) {
        let userURL = webserviceURL.appendingPathComponent("/profile")
        dataTask(with: userURL) { data, response, error in
            callback(Result {
                if let e = error { throw e }
                guard let d = data else { throw NetworkError.noData }
                return try JSONDecoder().decode(User.self, from: d)
            })
        }.resume()
    }
}

extension URLSession {
    func load<A>(url: URL,
                 parse: @escaping (Data) throws -> A,
                 callback: @escaping (Result<A, Error>) -> ()) {
        dataTask(with: url) { data, response, error in
            callback(Result {
                if let e = error { throw e }
                guard let d = data else { throw NetworkError.noData }
                return try parse(d)
            })
        }.resume()
    }
}

struct BlogPost: Decodable {}

let profileURL = webserviceURL.appendingPathComponent("profile")

URLSession.shared.load(url: profileURL, parse: {
    try JSONDecoder().decode(User.self, from: $0)
}) { print($0) }

let postURL = webserviceURL.appendingPathComponent("blog")

URLSession.shared.load(url: postURL, parse: {
    try JSONDecoder().decode(BlogPost.self, from: $0)
}) { print($0) }


struct Resource<A> {
    let url: URL
    let parse: (Data) throws -> A
}

let profile = Resource<User>(url: profileURL, parse: {
    try JSONDecoder().decode(User.self, from: $0)
})

let post = Resource<BlogPost>(url: postURL, parse: {
    try JSONDecoder().decode(BlogPost.self, from: $0)
})

extension Resource where A: Decodable {
    init(json url: URL) {
        self.url = url
        self.parse = { data in
            try JSONDecoder().decode(A.self, from: data)
        }
    }
}

extension URLSession {
    func load<A>(_ r: Resource<A>,
                 callback: @escaping (Result<A, Error>) -> ()) {
        dataTask(with: r.url) { data, response, err in
            callback(Result {
                if let e = err { throw e }
                guard let d = data else { throw NetworkError.noData }
                return try r.parse(d)
            })
        }.resume()
    }
}

URLSession.shared.load(profile) { result in
    print(result)
}
