//
//  GroupingOption.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 02/05/2026.
//

import Foundation

enum GroupingOption: String, CaseIterable, Identifiable {
    case none = "None"
    case ownerType = "Owner Type"
    case forkStatus = "Fork Status"
    
    var id: String { self.rawValue }
}
