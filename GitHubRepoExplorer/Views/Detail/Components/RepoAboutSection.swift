//
//  RepoAboutSection.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI

struct RepoAboutSection: View {
    let description: String?
    
    var body: some View {
        Section("About") {
            Text(description ?? "No description available")
                .font(.body)
                .accessibilityIdentifier("DetailDescription")
        }
    }
}
