//
//  ContentView.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = GitHubRepoViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteRepo]
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Group By", selection: $viewModel.selectedGrouping) {
                    ForEach(GitHubRepoViewModel.GroupingOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                
                ForEach(viewModel.groupKeys, id: \.self) { key in
                    Section(header: Text(key).accessibilityIdentifier("SectionHeader-\(key)")) {
                        ForEach(viewModel.groupedRepositories[key] ?? []) { repo in
                            NavigationLink(destination: GitHubRepDetailView(repo: repo)) {
                                GitHubRepoRowView(
                                    repo: repo,
                                    isBookmarked: favorites.contains(where: { $0.id == repo.id }),
                                    onBookmarkToggle: { toggleBookmark(repo) }
                                )
                            }
                            .onAppear {
                                if repo == viewModel.repositories.last {
                                    Task { await viewModel.loadMoreContent() }
                                }
                            }
                        }
                    }
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Fetching more...")
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("GitHub Explorer")
            .overlay {
                if let error = viewModel.errorMessage {
                    ContentUnavailableView {
                        Label("Error", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error)
                    } actions: {
                        Button("Retry") {
                            Task { await viewModel.loadMoreContent() }
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchInitialRepositories()
            }
        }
    }
    
    private func toggleBookmark(_ repo: Repository) {
        if let existing = favorites.first(where: { $0.id == repo.id }) {
            modelContext.delete(existing)
        } else {
            let fav = FavoriteRepo(
                id: repo.id,
                name: repo.name,
                fullName: repo.fullName,
                ownerLogin: repo.owner.login,
                ownerAvatarUrl: repo.owner.avatarUrl,
                repoDescription: repo.description
            )
            modelContext.insert(fav)
        }
    }
}

//#Preview {
//    HomeView()
//        .modelContainer(for: FavoriteRepo.self, inMemory: true)
//}
