//
//  ZeitgeistApp.swift
//  Zeitgeist
//
//  Created by Andrin Buholzer on 19.01.2024.
//

import SwiftUI

@main
struct ZeitgeistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
