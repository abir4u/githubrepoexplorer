//
//  MockRepositoryService.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Foundation
@testable import GitHubRepoExplorer // Replace with your actual project name

actor MockRepositoryService: RepositoryService {
    var mockRepos: [Repository] = []
    var shouldFail = false
    var nextUrlToReturn: String? = nil
    
    func setupMockData(repos: [Repository], shouldFail: Bool = false, nextUrl: String? = nil) {
        self.mockRepos = repos
        self.shouldFail = shouldFail
        self.nextUrlToReturn = nextUrl
    }

    func fetchRepositories(urlString: String) async throws -> (repos: [Repository], nextUrl: String?) {
        if shouldFail {
            throw NetworkError.rateLimitExceeded
        }
        return (mockRepos, nextUrlToReturn)
    }

    func fetchLanguages(url: String) async throws -> [String: Int] {
        return ["Swift": 1000]
    }
}
