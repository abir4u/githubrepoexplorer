//
//  Repository.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

struct Repository: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    let fork: Bool
    let languagesUrl: String
    let stargazersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, fork, description
        case fullName = "full_name"
        case owner
        case languagesUrl = "languages_url"
        case stargazersCount = "stargazers_count"
    }
}

struct Owner: Codable, Hashable {
    let login: String
    let avatarUrl: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case login, type
        case avatarUrl = "avatar_url"
    }
}
