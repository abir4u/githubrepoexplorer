//
//  RepoDetailViewModel.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 02/05/2026.
//

import Foundation
import Observation

@Observable
final class GitHubRepoDetailViewModel {
    private let service: RepositoryService
    private let languagesUrl: String
    
    var languages: [String: Int] = [:]
    var isLoading = false
    var errorMessage: String? = nil
    
    var sortedLanguages: [(name: String, bytes: Int)] {
        languages
            .map { (name: $0.key, bytes: $0.value) }
            .sorted { $0.bytes > $1.bytes }
    }

    init(languagesUrl: String, service: RepositoryService = NetworkClient()) {
        self.languagesUrl = languagesUrl
        self.service = service
    }

    @Sendable
    func loadLanguages() async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        
        do {
            languages = try await service.fetchLanguages(url: languagesUrl)
        } catch {
            errorMessage = "Failed to load languages. Please try again."
        }        
    }
}
