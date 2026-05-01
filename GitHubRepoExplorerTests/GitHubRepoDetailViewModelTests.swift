//
//  GitHubRepoDetailViewModelTests.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 02/05/2026.
//

import Testing
@testable import GitHubRepoExplorer

@Suite("Detail ViewModel Tests")
struct GitHubRepoDetailViewModelTests {
    
    @Test("Languages should be sorted by byte count descending")
    @MainActor
    func testLanguageSorting() async {
        let vm = GitHubRepoDetailViewModel(languagesUrl: "mock_url")
        
        vm.languages = [
            "Python": 100,
            "Swift": 500,
            "JavaScript": 250
        ]
        
        let results = vm.sortedLanguages
        
        #expect(results.count == 3)
        #expect(results[0].name == "Swift")      // 500 bytes (Largest)
        #expect(results[1].name == "JavaScript") // 250 bytes
        #expect(results[2].name == "Python")     // 100 bytes (Smallest)
    }
    
    @Test("Languages should be fetched and then sorted")
    @MainActor
    func testFullLanguageFlow() async {
        let mockService = MockRepositoryService()
        let mockData = ["Python": 100, "Swift": 500]
        
        await mockService.setupMockData(repos: [], languages: mockData)
        
        let vm = GitHubRepoDetailViewModel(languagesUrl: "mock_url", service: mockService)
        
        await vm.loadLanguages()
        
        #expect(vm.sortedLanguages[0].name == "Swift")
    }
    
    @Test("Error message should be set when fetch fails")
    @MainActor
    func testFetchFailureSetsErrorMessage() async {
        let mockService = MockRepositoryService()
        await mockService.setupMockData(repos: [], shouldFailLanguages: true)
        
        let vm = GitHubRepoDetailViewModel(languagesUrl: "fail_url", service: mockService)
        
        await vm.loadLanguages()
        
        #expect(vm.errorMessage != nil)
        #expect(vm.languages.isEmpty)
        #expect(vm.isLoading == false)
    }
    
    @Test("Should handle empty language response")
    @MainActor
    func testEmptyLanguages() async {
        let mockService = MockRepositoryService()
        let vm = GitHubRepoDetailViewModel(languagesUrl: "empty_url", service: mockService)
                
        await vm.loadLanguages()
        
        #expect(vm.languages.isEmpty)
        #expect(vm.sortedLanguages.isEmpty)
        #expect(vm.errorMessage == nil)
    }

    @Test("isLoading should be true while fetching")
    @MainActor
    func testLoadingState() async {
        let vm = GitHubRepoDetailViewModel(languagesUrl: "url")
        
        let task = Task { await vm.loadLanguages() }
        
        await Task.yield()
        
        #expect(vm.isLoading == true)
        
        await task.value
        #expect(vm.isLoading == false)
    }

    @Test("Should clear previous error when retrying")
    @MainActor
    func testErrorClearsOnRetry() async {
        let mockService = MockRepositoryService()
        let vm = GitHubRepoDetailViewModel(languagesUrl: "url", service: mockService)
        
        await mockService.setupMockData(repos: [], shouldFailLanguages: true)
        await vm.loadLanguages()
        #expect(vm.errorMessage != nil)
        
        await mockService.setupMockData(repos: [], shouldFailLanguages: false)
        
        let task = Task { await vm.loadLanguages() }
        
        await Task.yield()
        
        #expect(vm.errorMessage == nil)
        
        await task.value
    }
}
