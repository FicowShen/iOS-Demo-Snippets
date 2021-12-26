//
//  EmailCheckingRequest.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/26.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct EmailCheckingRequest {

    let email: String

    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                if self.email.lowercased() == "ficowshen@hotmail.com" {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
