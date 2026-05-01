//
//  NetworkClientTests.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 02/05/2026.
//


import Testing
@testable import GitHubRepoExplorer

@Suite("Link Header Parser Tests")
struct NetworkClientTests {
    
    let client = NetworkClient()

    @Test("Header with a 'next' link should be parsed correctly")
    func testParseNextLink() {
        let header = "<https://github.com>; rel=\"next\", <https://github.com>; rel=\"last\""
        
        let result = client.parseNextPageUrl(from: header)
        
        #expect(result == "https://github.com")
    }

    @Test("Header without a 'next' link should return nil")
    func testParseNoNextLink() {
        let header = "<https://github.com>; rel=\"prev\", <https://github.com>; rel=\"first\""
        
        let result = client.parseNextPageUrl(from: header)
        
        #expect(result == nil)
    }

    @Test("Malformed header should return nil safely")
    func testParseMalformedHeader() {
        let header = "random-string-without-brackets-or-rel"
        
        let result = client.parseNextPageUrl(from: header)
        
        #expect(result == nil)
    }

    @Test("Header with extra whitespace should still work")
    func testParseHeaderWithWhitespace() {
        let header = "   <https://github.com>   ;   rel  =  \"next\"  "
        
        let result = client.parseNextPageUrl(from: header)
        
        #expect(result == "https://github.com")
    }
}
