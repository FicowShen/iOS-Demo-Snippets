//
//  WriteUserAppCommand.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

// replace with didSet and property wrapper
struct WriteUserAppCommand: AppCommand {
    let user: User

    func execute(in store: Store) {
        try? FileHelper.writeJSON(
            user,
            to: .documentDirectory,
            fileName: "user.json"
        )
    }
}
