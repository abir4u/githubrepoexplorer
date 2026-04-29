//
//  NetworkClient.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case rateLimitExceeded
    case decodingError
    case serverError(Int)
}

actor NetworkClient: RepositoryService {
    func fetchRepositories(urlString: String) async throws -> (repos: [Repository], nextUrl: String?) {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(0)
        }
        
        if httpResponse.statusCode == 403 {
            throw NetworkError.rateLimitExceeded
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let repos = try JSONDecoder().decode([Repository].self, from: data)
            let nextUrl = parseNextPageUrl(from: httpResponse)
            return (repos, nextUrl)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    private func parseNextPageUrl(from response: HTTPURLResponse) -> String? {
        guard let linkHeader = response.value(forHTTPHeaderField: "Link") else { return nil }
        
        // Example header: <https://github.com>; rel="next", <https://github.com{?since}>; rel="first"
        let links = linkHeader.components(separatedBy: ",")
        
        for link in links {
            let segments = link.components(separatedBy: ";")
            guard segments.count > 1 else { continue }
            
            let urlPart = segments[0].trimmingCharacters(in: CharacterSet(charactersIn: "<> "))
            let relPart = segments[1].trimmingCharacters(in: .whitespaces)
            
            if relPart == "rel=\"next\"" {
                return urlPart
            }
        }
        return nil
    }
}
