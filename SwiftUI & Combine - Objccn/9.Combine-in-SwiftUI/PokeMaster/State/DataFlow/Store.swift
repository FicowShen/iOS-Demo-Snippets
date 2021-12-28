//
//  Store.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/03.
//  Copyright © 2019 OneV's Den. All rights reserved.
//


import Combine

class Store: ObservableObject {
    @Published var appState = AppState()
    private var disposeBag = [AnyCancellable]()

    init() {
        setupObservers()
    }

    func setupObservers() {
        appState.settings.checker.isEmailValid.sink { isValid in
            self.dispatch(.emailValid(valid: isValid))
        }.store(in: &disposeBag)
        appState.settings.checker.isRegisterValid.sink { enabled in
            self.dispatch(.isRegisterValid(valid: enabled))
        }.store(in: &disposeBag)
    }

    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]: \(command)")
            #endif
            command.execute(in: self)
        }
    }

    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?

        switch action {
        case .register(let email, let password):
            guard !appState.settings.accountValidating else { break }
            appState.settings.accountValidating = true
            appCommand = RegisterAppCommand(email: email, password: password)
        case .login(let email, let password):
            guard !appState.settings.accountValidating else { break }
            appState.settings.accountValidating = true
            appCommand = LoginAppCommand(email: email, password: password)
        case .accountBehaviorDone(let result):
            appState.settings.accountValidating = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
            }
        case .logout:
            appState.settings.loginUser = nil
        case .emailValid(let valid):
            appState.settings.isEmailValid = valid
        case .loadPokemons:
            if case .loading = appState.pokemonList.loadingStatus {
                break
            }
            appState.pokemonList.loadingStatus = .loading
            appCommand = LoadPokemonsCommand()
        case .loadPokemonsDone(let result):
            switch result {
            case .success(let models):
                appState.pokemonList.pokemons = Dictionary(
                    uniqueKeysWithValues: models.map { ($0.id, $0) }
                )
                appState.pokemonList.loadingStatus = .loaded
            case .failure(let error):
                print(error)
                appState.pokemonList.loadingStatus = .failed(error)
            }
        case .isRegisterValid(let valid):
            appState.settings.isRegisterValid = valid
        case .clearCache:
            appState.pokemonList.pokemons = nil
            appState.pokemonList.loadingStatus = .toLoad
        case .toggleListSelection(let index):
            if appState.pokemonList.operation.expandingIndex == index {
                appState.pokemonList.operation.expandingIndex = nil
            } else {
                appState.pokemonList.operation.expandingIndex = index
            }
        }

        return (appState, appCommand)
    }
}
