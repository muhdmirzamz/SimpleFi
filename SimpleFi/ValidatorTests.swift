//
//  ValidatorTests.swift
//  SimpleTodo
//
//  Created by Muhd Mirza on 14/12/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import XCTest
import CoreData
@testable import SimpleFi

class ValidatorTests: XCTestCase {

	var validator = Validator()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
	
	func testIfItemHasDuplicateInArray() {
		let context = self.setupInMemoryManagedObjectContext()
		var array = [NSManagedObject]()
		
		let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		item?.filePath = "/testitem"
		item?.name = "testitem"
		item?.level = 0
		item?.isFolder = false
		
		array.append(item!)
		
		if array.count == 1 {
			print(array[0])
		}
		
		XCTAssertTrue(self.validator.item(Named: "testitem", HasDuplicateInArray: array), "Item should be a duplicate")
	}
	
	func testIfItemHasIncorrectParentPath() {
		let context = self.setupInMemoryManagedObjectContext()
		
		let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		item?.filePath = "/folder1/testitem"
		item?.name = "testitem"
		item?.level = 0
		item?.isFolder = false
		
		XCTAssertTrue(self.validator.item(item!, hasIncorrectParentPathComparedTo: "/folder2/"), "Item should have incorrect parent path")
	}
	
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func setupInMemoryManagedObjectContext() -> NSManagedObjectContext {
		let managedObjectModel = NSManagedObjectModel.mergedModel(from: [.main])!

		let persistentContainer = NSPersistentContainer.init(name: "SimpleTodo", managedObjectModel: managedObjectModel)
		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		
		return persistentContainer.viewContext
	}
	
}
