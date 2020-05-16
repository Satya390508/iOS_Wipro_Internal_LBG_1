//
//  LBG_1UITests.swift
//  LBG_1UITests
//
//  Created by SatyaRanjan Mohapatra on 12/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import XCTest

class LBG_1UITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApplicationFlow() {
        // UI tests must launch the application that they test.
	let app = XCUIApplication()
	app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
	
	
	let albumListTable = app.tables.element(matching: .table, identifier: "AlbumListTable")
	let albumSearchBar = app.searchFields["Search albums here!"]
	albumSearchBar.tap()
	albumSearchBar.typeText("Believe")
		
	let searchBtn = app.buttons["Search"]
	let clearBtn = albumSearchBar.buttons["Clear text"]
	searchBtn.tap()
	
	let tableCell = albumListTable.cells.element(matching: .cell, identifier: "AlbumListCell_0")
	let existsPredicate = NSPredicate(format: "exists == true")
	expectation(for: existsPredicate, evaluatedWith: tableCell, handler: nil)
	waitForExpectations(timeout: 5) { (error) in
		if error != nil {
			XCTFail("Error: \(error!.localizedDescription)")
		}
	}
	tableCell.waitForExistence(timeout: 5)
	tableCell.tap()
	
	// Detail View loaded
	let albumDetailNavBar = app.navigationBars["LBG_1.AlbumDetailVC"]
	XCTAssertFalse(albumDetailNavBar.exists)

	let backButton = app.buttons["Back"]
	backButton.tap()
	
	// Back to List View
	clearBtn.tap()
	app.buttons["Cancel"].tap()
	XCTAssertFalse(albumSearchBar.label.isEmpty)
	
	albumListTable.swipeUp()
	albumListTable.swipeDown()
	albumListTable.swipeDown()
	albumListTable.swipeDown()
	albumListTable.swipeUp()
	albumListTable.swipeUp()
	albumListTable.swipeUp()
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
