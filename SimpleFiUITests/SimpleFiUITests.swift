//
//  SimpleFiUITests.swift
//  SimpleFi
//
//  Created by Muhd Mirza on 25/12/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import XCTest

class SimpleFiUITests: XCTestCase {

	/*
		Note about UI tests:
		Core data contents follow through across individual tests.
		There is apparently no way of accessing core data mechanism in UI tests.
		Creation and deletion of in-memory core data is not possible.
		Maybe it is possible, I just have not searched hard enough.
	*/
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddFolder() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		let app = XCUIApplication()
		app.navigationBars["SimpleFi.HomeTableView"].buttons["ic more horiz white"].tap()
		app.sheets["Add"].buttons["Add folder"].tap()
		
		let addFolderAlert = app.alerts["Add Folder"]
		addFolderAlert.collectionViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.typeText("folder3")
		addFolderAlert.buttons["Ok"].tap()
		
		let tablesQuery = XCUIApplication().tables
		XCTAssertTrue(tablesQuery.staticTexts["folder3"].exists, "folder3 should be there")
    }
	
	func testDeleteFolder() {
		let tablesQuery = XCUIApplication().tables
		tablesQuery.staticTexts["folder3"].swipeLeft()
		tablesQuery.buttons["Delete"].tap()
		
		XCTAssertFalse(tablesQuery.staticTexts["folder3"].exists, "folder3 should be gone")
	}
	
	func testAddFile() {
		let app = XCUIApplication()
		app.navigationBars["SimpleFi.HomeTableView"].buttons["ic more horiz white"].tap()
		app.sheets["Add"].buttons["Add file"].tap()
		
		let addItemAlert = app.alerts["Add Item"]
		addItemAlert.collectionViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.typeText("file1")
		addItemAlert.buttons["Ok"].tap()
		
		let tablesQuery = XCUIApplication().tables
		XCTAssertTrue(tablesQuery.staticTexts["file1"].exists, "file1 should be there")
	}
	
	func testDeleteFile() {
		let tablesQuery = XCUIApplication().tables
		
		tablesQuery.staticTexts["file1"].swipeLeft()
		tablesQuery.buttons["Delete"].tap()
		
		XCTAssertFalse(tablesQuery.staticTexts["file1"].exists, "file1 should be gone")
	}
	
	func testAddDuplicateFileNameErrorAlert() {
		let app = XCUIApplication()
		let button = app.navigationBars["SimpleFi.HomeTableView"].children(matching: .button).element
		button.tap()
		
		let addFileButton = app.sheets["Add"].buttons["Add file"]
		addFileButton.tap()
		
		let addItemAlert = app.alerts["Add Item"]
		let textField = addItemAlert.collectionViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
		textField.typeText("item2")
		
		let okButton = addItemAlert.buttons["Ok"]
		okButton.tap()
		button.tap()
		addFileButton.tap()
		textField.typeText("item2")
		okButton.tap()
		XCTAssertTrue(app.alerts["Wait"].exists, "There should be an alert")
		
		let tablesQuery = XCUIApplication().tables
		tablesQuery.staticTexts["item2"].swipeLeft()
		tablesQuery.buttons["Delete"].tap()
	}
	
	func testAddEmptyFileNameErrorAlert() {
		let app = XCUIApplication()
		app.navigationBars["SimpleFi.HomeTableView"].buttons["ic more horiz white"].tap()
		app.sheets["Add"].buttons["Add file"].tap()
		app.alerts["Add Item"].buttons["Ok"].tap()
		
		XCTAssertTrue(app.alerts["Wait"].exists, "There should be an alert")
	}
	
	func testAddDuplicateFolderNameErrorAlert() {
		let app = XCUIApplication()
		let icMoreHorizWhiteButton = app.navigationBars["SimpleFi.HomeTableView"].buttons["ic more horiz white"]
		icMoreHorizWhiteButton.tap()
		
		let addFolderButton = app.sheets["Add"].buttons["Add folder"]
		addFolderButton.tap()
		
		let addFolderAlert = app.alerts["Add Folder"]
		let textField = addFolderAlert.collectionViews.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element
		textField.typeText("folder4")
		
		let okButton = addFolderAlert.buttons["Ok"]
		okButton.tap()
		icMoreHorizWhiteButton.tap()
		addFolderButton.tap()
		textField.typeText("folder4")
		okButton.tap()
		
		XCTAssertTrue(app.alerts["Wait"].exists, "There should be an alert")
		
		let tablesQuery = XCUIApplication().tables
		tablesQuery.staticTexts["folder4"].swipeLeft()
		tablesQuery.buttons["Delete"].tap()
	}
	
	func testAddEmptyFolderNameErrorAlert() {
		let app = XCUIApplication()
		app.navigationBars["SimpleFi.HomeTableView"].buttons["ic more horiz white"].tap()
		app.sheets["Add"].buttons["Add folder"].tap()
		app.alerts["Add Folder"].buttons["Ok"].tap()
		
		XCTAssertTrue(app.alerts["Wait"].exists, "There should be an alert")
	}
}
