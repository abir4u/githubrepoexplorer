//
//  RepoGroupingPicker.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import SwiftUI

struct RepoGroupingPicker: View {
    @Binding var selection: GitHubRepoViewModel.GroupingOption
    
    var body: some View {
        Picker("Group By", selection: $selection) {
            ForEach(GitHubRepoViewModel.GroupingOption.allCases, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(.segmented)
        .listRowBackground(Color.clear)
    }
}
