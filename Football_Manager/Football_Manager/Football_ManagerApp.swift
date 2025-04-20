//
//  Football_ManagerApp.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 18/04/25.
//

import SwiftUI
import SwiftData

@main
struct Football_ManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Player.self) // Attach the ModelContainer
        }
    }
}
