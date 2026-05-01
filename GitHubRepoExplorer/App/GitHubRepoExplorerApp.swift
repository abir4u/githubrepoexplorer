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
    let service: RepositoryService

    init() {
        if ProcessInfo.processInfo.arguments.contains("-UseMockData") {
            self.service = MockRepositoryService()
        } else {
            self.service = NetworkClient()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: FavoriteRepo.self)
    }
}
