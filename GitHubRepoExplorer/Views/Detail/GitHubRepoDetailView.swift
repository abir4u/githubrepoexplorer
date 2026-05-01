//
//  GitHubRepDetailView.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI

struct GitHubRepoDetailView: View {
    let repo: Repository
    @State private var viewModel: GitHubRepoDetailViewModel
    
    init(repo: Repository, service: RepositoryService = NetworkClient()) {
        self.repo = repo
        _viewModel = State(initialValue: GitHubRepoDetailViewModel(
                    languagesUrl: repo.languagesUrl,
                    service: service
                ))
    }
    
    var body: some View {
        List {
            RepoAboutSection(description: repo.description)
            
            Section("Languages") {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let error = viewModel.errorMessage {
                    Label(error, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                        .font(.footnote)
                } else if viewModel.languages.isEmpty {
                    Text("No language data found")
                        .foregroundStyle(.secondary)
                } else {
                    languageList
                }
            }
        }
        .navigationTitle(repo.name)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadLanguages() }
    }
    
    private var languageList: some View {
        ForEach(viewModel.sortedLanguages, id: \.name) { language in
            LanguageRow(name: language.name, bytes: language.bytes)
        }
    }
}
