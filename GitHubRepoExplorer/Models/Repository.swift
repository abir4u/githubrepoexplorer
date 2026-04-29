//
//  Repository.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

struct Repository: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let description: String?
    let fork: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, fork, description
        case fullName = "full_name"
        case owner
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
