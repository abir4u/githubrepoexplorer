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
                RepoGroupingPicker(selection: $viewModel.selectedGrouping)
                
                repoSections
                
                if viewModel.isLoading {
                    loadingFooter
                }
            }
            .navigationTitle("GitHub Explorer")
            .overlay(errorOverlay)
            .task { await viewModel.fetchInitialRepositories() }
        }
    }
    
    // MARK: - Subviews
    
    private var repoSections: some View {
        ForEach(viewModel.groupKeys, id: \.self) { key in
            RepoSection(
                title: key,
                repos: viewModel.groupedRepositories[key] ?? [],
                isLastSection: key == viewModel.groupKeys.last,
                favorites: favorites,
                onBookmarkToggle: toggleBookmark,
                onLoadMore: { Task { await viewModel.loadMoreContent() } }
            )
        }
    }
    
    private var loadingFooter: some View {
        HStack {
            Spacer()
            ProgressView("Fetching more...")
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
    
    @ViewBuilder
    private var errorOverlay: some View {
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
    
    // MARK: - Actions
    
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

#Preview {
    HomeView()
        .modelContainer(for: FavoriteRepo.self, inMemory: true)
}
