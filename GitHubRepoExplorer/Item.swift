//
//  Item.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
