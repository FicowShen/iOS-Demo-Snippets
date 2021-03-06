//
//  AppAction.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/05.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

enum AppAction {
    case register(email: String, password: String)
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    case logout
    case emailValid(valid: Bool)
    case loadPokemons
    case loadPokemonsDone(
            result: Result<[PokemonViewModel], AppError>
         )
    case isRegisterValid(valid: Bool)
    case clearCache
    case toggleListSelection(index: Int)
}
