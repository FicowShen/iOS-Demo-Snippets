//
//  Store.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine

class Store: ObservableObject {
    @Published var appState = AppState()

    static func reduce(
        state: AppState,
        action: AppAction
    ) -> AppState
    {
        var appState = state

        switch action {
        case .login(let email, let password):
            if password == "password" {
                let user = User(email: email, favoritePokemonIDs: [])
                appState.settings.loginUser = user
            }
        }
        return appState
    }
}
