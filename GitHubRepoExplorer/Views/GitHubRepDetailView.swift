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
            RepoAboutSection(description: repo.description)
            
            Section("Languages") {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if languages.isEmpty {
                    ContentUnavailableView("No Data", systemImage: "slash.circle", description: Text("No language data found."))
                } else {
                    languageList
                }
            }
        }
        .navigationTitle(repo.name)
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadLanguages() }
    }
    
    private var languageList: some View {
        ForEach(languages.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
            LanguageRow(name: key, bytes: value)
        }
    }
    
    @Sendable
    private func loadLanguages() async {
        isLoading = true
        languages = (try? await service.fetchLanguages(url: repo.languagesUrl)) ?? [:]
        isLoading = false
    }
}
