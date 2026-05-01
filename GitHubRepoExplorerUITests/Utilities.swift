//
//  Utilities.swift
//  GitHubRepoExplorer
//
//  Created by Abir Pal on 29/04/2026.
//

import XCTest

public func assertElementExists(app: XCUIApplication, identifier: String, errorMessage: String = "", timeout: TimeInterval = 2) {
    let message = errorMessage == "" ? "Unable to locate element with identifier '\(identifier)'" : errorMessage
    XCTAssertTrue(app.staticTexts[identifier].waitForExistence(timeout: timeout), message)
}
