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
    private var languageCache: [String: [String: Int]] = [:]

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
            let nextUrl = parseNextPageUrl(from: httpResponse.value(forHTTPHeaderField: "Link") ?? "")
            return (repos, nextUrl)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    nonisolated func parseNextPageUrl(from linkHeader: String) -> String? {
        let links = linkHeader.components(separatedBy: ",")
        
        for link in links {
            let segments = link.components(separatedBy: ";")
            guard segments.count > 1 else { continue }
            
            let urlPart = segments[0].trimmingCharacters(in: CharacterSet(charactersIn: "<> "))
            
            let relPart = segments[1].replacingOccurrences(of: " ", with: "")
            
            if relPart == "rel=\"next\"" {
                return urlPart
            }
        }
        return nil
    }
    
    func fetchLanguages(url: String) async throws -> [String: Int] {
        if let cached = languageCache[url] { return cached }
        
        guard let urlObj = URL(string: url) else { throw NetworkError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: urlObj)
        
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
            let languages = try JSONDecoder().decode([String: Int].self, from: data)
            languageCache[url] = languages
            return languages
        } catch {
            throw NetworkError.decodingError
        }
    }
}
