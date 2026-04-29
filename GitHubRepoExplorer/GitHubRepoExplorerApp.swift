//
//  GitHubRepoExplorerApp.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI
import SwiftData

@main
struct GitHubRepoExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FavoriteRepo.self)
    }
}
