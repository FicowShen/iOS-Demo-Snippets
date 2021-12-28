//
//  AppState.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/04.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Combine
import Foundation

struct AppState {
    var settings = Settings()
    var pokemonList = PokemonList()
}

extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }

        enum AccountBehavior: CaseIterable {
            case register, login
        }

        var checker = AccountChecker()
        var isEmailValid = false
        var isRegisterValid = false

        //        var accountBehavior = AccountBehavior.login
        //        var email = ""
        //        var password = ""
        //        var verifyPassword = ""
        
        var showEnglishName = true
        var sorting = Sorting.id
        var showFavoriteOnly = false

        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?

        var accountValidating = false
        var loginError: AppError?
    }
}

extension AppState {
    class AccountChecker {
        @Published var accountBehavior = AppState.Settings.AccountBehavior.login
        @Published var email = ""
        @Published var password = ""
        @Published var verifyPassword = ""

        var isEmailValid: AnyPublisher<Bool, Never> {
            let remoteVerify = $email.debounce(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main
            )
            .removeDuplicates()
            .flatMap { email -> AnyPublisher<Bool, Never> in
                let validEmail = email.isValidEmailAddress
                let canSkip = self.accountBehavior == .login
                switch (validEmail, canSkip) {
                case (false, _):
                    return Just(false).eraseToAnyPublisher()
                case (true, false):
                    return EmailCheckingRequest(email: email)
                        .publisher
                        .eraseToAnyPublisher()
                case (true, true):
                    return Just(true).eraseToAnyPublisher()
                }
            }
            let emailLocalValid = $email.map {
                $0.isValidEmailAddress
            }
            let canSkipRemoteVerify = $accountBehavior.map {
                $0 == .login
            }
            return Publishers.CombineLatest3(
                emailLocalValid, canSkipRemoteVerify, remoteVerify
            )
            .map { $0 && ($1 || $2) }
            .eraseToAnyPublisher()
        }

        var isPasswordValid: AnyPublisher<Bool, Never> {
            $password.combineLatest($verifyPassword) { a, b in
                !a.isEmpty && !b.isEmpty && a == b
            }.eraseToAnyPublisher()
        }

        var isRegisterValid: AnyPublisher<Bool, Never> {
            isEmailValid
                .combineLatest(isPasswordValid) { $0 && $1 }
                .eraseToAnyPublisher()
        }

    }
}

extension AppState {
    struct PokemonList {
        enum Status {
            case toLoad, loading, loaded, failed(Error)
        }
        @FileStorage(
            directory: .cachesDirectory,
            fileName: "pokemons.json"
        )
        var pokemons: [Int: PokemonViewModel]?
        var loadingStatus: Status = .toLoad
        var operation = Operation()

        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted { $0.id < $1.id }
        }
    }

    final class Operation {
        @Published var expandingIndex: Int?
        @Published var searchText: String = ""
    }
}
