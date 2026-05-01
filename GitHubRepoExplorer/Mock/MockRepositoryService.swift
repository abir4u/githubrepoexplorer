//
//  MockRepositoryService.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Foundation

actor MockRepositoryService: RepositoryService {
    var mockRepos: [Repository] = []
    var shouldFail = false
    var shouldFailLanguages = false
    var nextUrlToReturn: String? = nil
    var mockLanguages: [String: Int] = [:]
    
    func setupMockData(
        repos: [Repository],
        shouldFail: Bool = false,
        shouldFailLanguages: Bool = false,
        nextUrl: String? = nil,
        languages: [String: Int] = [:]
    ) {
        self.mockRepos = repos
        self.shouldFail = shouldFail
        self.shouldFailLanguages = shouldFailLanguages
        self.nextUrlToReturn = nextUrl
        self.mockLanguages = languages
    }

    func fetchRepositories(urlString: String) async throws -> (repos: [Repository], nextUrl: String?) {
        if shouldFail {
            throw NetworkError.rateLimitExceeded
        }
        return (mockRepos, nextUrlToReturn)
    }

    func fetchLanguages(url: String) async throws -> [String: Int] {
        if shouldFailLanguages {
            throw NetworkError.serverError(500)
        }
        return mockLanguages
    }
}
