//
//  GitHubRepoExplorerMockUITests.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 02/05/2026.
//

import XCTest

final class GitHubRepoExplorerMockUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["-UseMockData"]
        app.launch()
    }

    func testAppFlow() throws {
        let navTitle = app.navigationBars["GitHub Explorer"]
        XCTAssertTrue(navTitle.exists, "The main navigation title should be visible.")

        let firstRow = app.buttons.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 10), "The list should load repositories from the API.")

        let forkStatusButton = app.buttons["Fork Status"]
        XCTAssertTrue(forkStatusButton.exists)
        forkStatusButton.tap()
        
        assertElementExists(app: app, identifier: "SectionHeader-Forks")

        let originalHeader = app.descendants(matching: .any).element(matching: NSPredicate(format: "label CONTAINS[c] 'Forks'"))
        XCTAssertTrue(originalHeader.waitForExistence(timeout: 5), "The 'Forks' section header should appear after grouping.")

        firstRow.tap()
        
        assertElementExists(app: app, identifier: "DetailDescription")
    }
}
