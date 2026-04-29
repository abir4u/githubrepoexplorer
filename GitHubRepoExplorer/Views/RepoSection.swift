//
//  RepoSection.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI

struct RepoSection: View {
    let title: String
    let repos: [Repository]
    let isLastSection: Bool
    let favorites: [FavoriteRepo]
    let onBookmarkToggle: (Repository) -> Void
    let onLoadMore: () -> Void

    var body: some View {
        Section(header: Text(title).accessibilityIdentifier("SectionHeader-\(title)")) {
            ForEach(repos) { repo in
                NavigationLink(destination: GitHubRepDetailView(repo: repo)) {
                    GitHubRepoRowView(
                        repo: repo,
                        isBookmarked: favorites.contains(where: { $0.id == repo.id }),
                        onBookmarkToggle: { onBookmarkToggle(repo) }
                    )
                }
                .onAppear {
                    if isLastSection && repo == repos.last {
                        onLoadMore()
                    }
                }
            }
        }
    }
}
