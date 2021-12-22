//
//  AppState.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/21.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct AppState {
    var settings = Settings()
}

extension AppState {
    struct Settings {
        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }
        var showEnglishName = true
        var sorting = Sorting.id
        var showFavoriteOnly = false

        enum AccountBehavior: CaseIterable {
            case register, login
        }
        var accountBehavior = AccountBehavior.login
        var email = ""
        var password = ""
        var verifyPassword = ""

        var loginUser: User?
        var loginError: AppError?
        var loginRequesting: Bool = false
    }
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}
