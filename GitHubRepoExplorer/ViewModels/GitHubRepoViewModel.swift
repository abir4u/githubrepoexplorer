//
//  GitHubRepoViewModel.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Foundation
import Observation

@Observable
class GitHubRepoViewModel {
    var repositories: [Repository] = []
    var isLoading = false
    var errorMessage: String?
    
    private var nextUrl: String? = "https://github.com"
    private let service: RepositoryService
    
    enum GroupingOption: String, CaseIterable {
        case none = "None"
        case ownerType = "Owner Type"
        case forkStatus = "Fork Status"
    }
    
    var selectedGrouping: GroupingOption = .none
    
    var groupedRepositories: [String: [Repository]] {
        switch selectedGrouping {
        case .none:
            return ["All": repositories]
        case .ownerType:
            return Dictionary(grouping: repositories, by: { $0.owner.type })
        case .forkStatus:
            return Dictionary(grouping: repositories, by: { $0.fork ? "Forks" : "Original" })
        }
    }
    
    // Sorted keys so the list sections don't jump around
    var groupKeys: [String] {
        groupedRepositories.keys.sorted()
    }

    init(service: RepositoryService = NetworkClient()) {
        self.service = service
    }

    @MainActor
    func fetchInitialRepositories() async {
        guard repositories.isEmpty else { return }
        await loadMoreContent()
    }

    @MainActor
    func loadMoreContent() async {
        guard !isLoading, let url = nextUrl else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let (newRepos, next) = try await service.fetchRepositories(urlString: url)
            self.repositories.append(contentsOf: newRepos)
            self.nextUrl = next
            self.isLoading = false
        } catch let error as NetworkError {
            handleError(error)
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.isLoading = false
        }
    }
    
    private func handleError(_ error: NetworkError) {
        isLoading = false
        switch error {
        case .rateLimitExceeded:
            errorMessage = "GitHub API rate limit exceeded. Please try again later."
        case .decodingError:
            errorMessage = "Failed to parse data from server."
        case .invalidURL:
            errorMessage = "Invalid request URL."
        case .serverError(let code):
            errorMessage = "Server returned an error: \(code)"
        }
    }
}
