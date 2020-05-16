//
//  ListViewControllerTest.swift
//  LBG_1Tests
//
//  Created by SatyaRanjan Mohapatra on 16/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import XCTest
@testable import LBG_1


class ListViewControllerTest: XCTestCase {
	
	var systemUnderTest: ViewController! // ==>  VC which shows searched Album list
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		super.setUp()
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		systemUnderTest = (storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
		_ = systemUnderTest.view // To make sure ViewDidLoad is called once from here
		
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		
		systemUnderTest = nil
		super.tearDown()
	}
	
	func test_SUT_IsInstantiable() {
		XCTAssertNotNil(systemUnderTest)
	}
	
	
	// MARK: - TableView test cases
	func test_SUT_HasTableView() {
		XCTAssertNotNil(systemUnderTest.tableView)
	}
	func test_SUT_ShouldSetTableViewDataSource() {
		XCTAssertNotNil(systemUnderTest.tableView.dataSource)
	}
	func test_SUT_ShouldSetTableViewDelegate() {
		XCTAssertNotNil(systemUnderTest.tableView.delegate)
	}

	// MARK: - SearchController test cases
	func test_SUT_HasSearchController() {
		XCTAssertNotNil(systemUnderTest.searchController)
	}
	func test_SUT_ShouldSetSearchResultUpdatingDelegate() {
		XCTAssertNotNil(systemUnderTest.searchController.searchResultsUpdater)
	}
	func test_SUT_ConformsToTableViewDataSourceProtocol() {
		XCTAssert( systemUnderTest.conforms(to: UITableViewDataSource.self))
		XCTAssertTrue(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:numberOfRowsInSection:))))
		XCTAssertTrue(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:cellForRowAt:))))
	}
	func test_SUT_ConformsToTableViewDelegateProtocol() {
		XCTAssert( systemUnderTest.conforms(to: UITableViewDelegate.self))
		XCTAssertTrue(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:didSelectRowAt:))))
	}

	// MARK: - SearchBar test cases
	func test_SUT_HasSearchBar() {
		XCTAssertNotNil(systemUnderTest.searchController.searchBar)
	}
	func test_SUT_ShouldSetSearchBarDelegate() {
		XCTAssertNotNil(systemUnderTest.searchController.searchBar.delegate)
	}
	func test_SUT_ConformsToSearchBarDelegateProtocol() {
		XCTAssert( systemUnderTest.conforms(to: UISearchBarDelegate.self))
		XCTAssertTrue(systemUnderTest.responds(to: #selector(systemUnderTest.searchBarSearchButtonClicked(_:))))
	}
	

	func test_NetworkCallInvocation() {
		systemUnderTest.searchController.searchBar.text = "believe" // as refered from REST API document page
		systemUnderTest.searchBarSearchButtonClicked(systemUnderTest.searchController.searchBar)
		
		var completionHandler  = false
		let currXpectation = expectation(description: "Completion handler invoked")
		NetworkServices.fetchAlbumList(for: systemUnderTest.searchController.searchBar.text!) { (responseData, errMsg) in
			completionHandler = true
			currXpectation.fulfill()
		}
		wait(for: [currXpectation], timeout: 5)
		XCTAssertTrue(completionHandler, "Completion handler never invoked")
	}


	func test_NetworkDataParsing() {
		systemUnderTest.searchController.searchBar.text = "believe" // as refered from REST API document page
		systemUnderTest.searchBarSearchButtonClicked(systemUnderTest.searchController.searchBar)
		
		var downloadedAlbumList: [Album]?
		let currXpectation = expectation(description: "Album List Received")
		NetworkServices.fetchAlbumList(for: systemUnderTest.searchController.searchBar.text!) { (responseData, errMsg) in
			
			if errMsg != nil {
				XCTFail("Error:: \(errMsg!)")
			}
			
			guard let receivedData = responseData, receivedData.count > 0 else {
				XCTFail("No Data received")
				return
			}
			
			do {
				let albumSearchResult = try JSONDecoder().decode(AlbumSearchResult.self, from: receivedData)
				if let searchItem = albumSearchResult.searchItem {
					downloadedAlbumList = searchItem.albums
				}
				else {
					downloadedAlbumList = [Album]()
				}
				currXpectation.fulfill()
			}
			catch {
				XCTFail("Error:: \(error.localizedDescription)")
			}
		}
		wait(for: [currXpectation], timeout: 5)
		XCTAssertNotNil(downloadedAlbumList, "Downloaded AlbumList should not be nil")
	}	
}
