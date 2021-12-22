//
//  AppCommand.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/22.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    let email: String
    let password: String

    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(
            email: email,
            password: password
        )
        .publisher
        .sink(
            receiveCompletion: { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.accountBehaviorDone(result: .failure(error)))
                }
                token.unseal()
            },
            receiveValue: { user in
                store.dispatch(
                    .accountBehaviorDone(result: .success(user))
                )
            }
        )
        .seal(in: token)
    }
}
