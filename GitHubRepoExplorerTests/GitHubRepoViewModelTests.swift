//
//  GitHubRepoViewModelTests.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Testing
import Foundation
@testable import GitHubRepoExplorer

@Suite("ViewModel Tests")
struct GitHubRepoViewModelTests {

    @Test("Initial fetch populates repositories")
    @MainActor
    func testInitialFetch() async throws {
        let mockService = MockRepositoryService()
        let sampleRepo = Repository(id: 1, name: "Test", fullName: "Test/Repo", owner: Owner(login: "user", avatarUrl: "", type: "User"), description: nil, fork: false, languagesUrl: "", stargazersCount: 0)
        
        await mockService.setupMockData(repos: [sampleRepo])
        
        let viewModel = GitHubRepoViewModel(service: mockService)

        await viewModel.fetchInitialRepositories()

        #expect(viewModel.repositories.count == 1)
        #expect(viewModel.repositories.first?.name == "Test")
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Handling Rate Limit Error")
    @MainActor
    func testRateLimitError() async throws {
        let mockService = MockRepositoryService()
        await mockService.setupMockData(repos: [], shouldFail: true)
        let viewModel = GitHubRepoViewModel(service: mockService)

        await viewModel.fetchInitialRepositories()

        #expect(viewModel.repositories.isEmpty)
        #expect(viewModel.errorMessage == "GitHub API rate limit exceeded. Please try again later.")
    }

    @Test("Grouping by Fork Status")
    @MainActor
    func testGroupingLogic() async throws {
        let mockService = MockRepositoryService()
        let repo1 = Repository(id: 1, name: "Original", fullName: "O/G", owner: Owner(login: "u", avatarUrl: "", type: "User"), description: nil, fork: false, languagesUrl: "", stargazersCount: 0)
        let repo2 = Repository(id: 2, name: "Forked", fullName: "F/K", owner: Owner(login: "u", avatarUrl: "", type: "User"), description: nil, fork: true, languagesUrl: "", stargazersCount: 0)
        
        await mockService.setupMockData(repos: [repo1, repo2])
        let viewModel = GitHubRepoViewModel(service: mockService)
        
        await viewModel.fetchInitialRepositories()
        viewModel.selectedGrouping = .forkStatus

        let groups = viewModel.groupedRepositories
        #expect(groups["Original"]?.count == 1)
        #expect(groups["Forks"]?.count == 1)
    }
}
