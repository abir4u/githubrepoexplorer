//
//  FavouritesRepo.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Foundation
import SwiftData

@Model
final class FavoriteRepo {
    @Attribute(.unique) var id: Int // Use GitHub's unique repo ID
    var name: String
    var fullName: String
    var ownerLogin: String
    var ownerAvatarUrl: String
    var repoDescription: String?
    var addedAt: Date
    
    init(id: Int, name: String, fullName: String, ownerLogin: String, ownerAvatarUrl: String, repoDescription: String? = nil) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.ownerLogin = ownerLogin
        self.ownerAvatarUrl = ownerAvatarUrl
        self.repoDescription = repoDescription
        self.addedAt = Date()
    }
}
