//
//  LayoutApp.swift
//  Layout
//
//  Created by Ficow on 2021/12/29.
//

import SwiftUI

@main
struct LayoutApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
