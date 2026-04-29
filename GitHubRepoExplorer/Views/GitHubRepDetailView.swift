//
//  GitHubRepDetailView.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI

struct GitHubRepDetailView: View {
    let repo: Repository
    @State private var languages: [String: Int] = [:]
    @State private var isLoading = false
    let service: RepositoryService = NetworkClient()
    
    var body: some View {
        List {
            Section("About") {
                Text(repo.description ?? "No description available")
            }
            
            Section("Languages") {
                if isLoading {
                    ProgressView()
                } else if languages.isEmpty {
                    Text("No language data")
                } else {
                    ForEach(languages.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                        HStack {
                            Text(key)
                            Spacer()
                            Text("\(value) bytes").foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(repo.name)
        .task {
            isLoading = true
            languages = (try? await service.fetchLanguages(url: repo.languagesUrl)) ?? [:]
            isLoading = false
        }
    }
}
