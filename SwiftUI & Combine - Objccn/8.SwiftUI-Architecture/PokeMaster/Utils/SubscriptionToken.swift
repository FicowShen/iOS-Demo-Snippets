//
//  SubscriptionToken.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/22.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Combine

final class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
