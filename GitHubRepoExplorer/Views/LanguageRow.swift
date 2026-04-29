//
//  LanguageRow.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI

struct LanguageRow: View {
    let name: String
    let bytes: Int
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text("\(bytes) bytes")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
