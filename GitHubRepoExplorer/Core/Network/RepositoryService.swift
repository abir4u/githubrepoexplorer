//
//  RepositoryService.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Foundation

protocol RepositoryService: Sendable {
    func fetchRepositories(urlString: String) async throws -> (repos: [Repository], nextUrl: String?)
    func fetchLanguages(url: String) async throws -> [String: Int]
}
