//
//  AppError.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/09/07.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }

    case passwordWrong
    case networkingFailed(Error)
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong:
            return "密码错误"
        case .networkingFailed(let error):
            return error.localizedDescription
        }
    }
}
