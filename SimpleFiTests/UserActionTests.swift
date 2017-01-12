//
//  UserActionTests.swift
//  SimpleTodo
//
//  Created by Muhd Mirza on 20/12/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import XCTest
import CoreData
@testable import SimpleFi

class UserActionTests: XCTestCase {

	var userAction = UserAction()
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
	
	func testFetchRequestWithFilePathAndLevel() {
		let context = self.setupInMemoryManagedObjectContext()
	
		let folder = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		folder?.filePath = "/folder1/"
		folder?.isFolder = true
		folder?.level = 0
		folder?.name = "folder1"
		
		let file = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		file?.filePath = "/file"
		file?.isFolder = false
		file?.level = 0
		file?.name = "file"
		
		do {
			try context.save()
		} catch {
			print("Error")
		}
		
		var testArray = [NSManagedObject]()
		testArray = self.userAction.fetchRequest(WithFilePath: "/", AndLevel: 0)
		XCTAssertTrue(testArray.count == 2, "Test array count should be 2")
	}
	
	// for previous bug relating to structure
	func testFetchRequestWithFilePathAndLevelBug() {
		let context = self.setupInMemoryManagedObjectContext()
		
		let folder = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		folder?.filePath = "/folder1/"
		folder?.isFolder = true
		folder?.level = 0
		folder?.name = "folder1"
		
		let folder2 = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		folder2?.filePath = "/folder2/"
		folder2?.isFolder = true
		folder2?.level = 0
		folder2?.name = "folder2"
		
		let file = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		file?.filePath = "/folder1/file1" // same file name but different parent path
		file?.isFolder = false
		file?.level = 1 // same level
		file?.name = "file1"
		
		let file2 = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		file2?.filePath = "/folder2/file1" // same file name but different parent path
		file2?.isFolder = false
		file2?.level = 1 // same level
		file2?.name = "file1"
		
		do {
			try context.save()
		} catch {
			print("Error")
		}
		
		var testArray = [NSManagedObject]()
		testArray = self.userAction.fetchRequest(WithFilePath: "/folder1/", AndLevel: 1)
		XCTAssertTrue(testArray.count == 1, "Test array count should be 1")
	}
	
	func testFetchRequest() {
		let context = self.setupInMemoryManagedObjectContext()
	
		let folder = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		folder?.filePath = "/folder1/"
		folder?.isFolder = true
		folder?.level = 0
		folder?.name = "folder1"
		
		do {
			try context.save()
		} catch {
			print("error")
		}
		
		let request = self.userAction.fetchRequest()
		
		var testArray = [NSManagedObject]()
		
		do {
			try testArray = context.fetch(request)
		} catch {
			print("error")
		}
		
		XCTAssertTrue(testArray.count == 1, "Test array should have one count")
	}
	
	func testAddFolder() {
		let context = self.setupInMemoryManagedObjectContext()
		var testArray = [NSManagedObject]()
		
		// retain this so you can make comparisons in assert statement
		let folder = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		folder?.filePath = "/folder1/"
		folder?.name = "folder1"
		folder?.level = 0
		folder?.isFolder = true
		
		// hardcode sample folder details here
		testArray = self.userAction.addItem(WithName: "folder1", AndLevel: 0, AndIsFolder: true, AtFilePath: "/folder1/", Into: testArray)
		
		let request = self.userAction.fetchRequest()
		
		do {
			try testArray = context.fetch(request)
		} catch {
			print("FAILED")
		}
		
		XCTAssertTrue(testArray.contains(folder!), "Test array should contain the specified folder")
	}
	
	func testAddFile() {
		let context = self.setupInMemoryManagedObjectContext()
		var testArray = [NSManagedObject]()
		
		// retain this so you can make comparisons in assert statement
		let file = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		file?.filePath = "/file1"
		file?.name = "file1"
		file?.level = 0
		file?.isFolder = false
		
		// hardcode sample folder details here
		testArray = self.userAction.addItem(WithName: "file1", AndLevel: 0, AndIsFolder: false, AtFilePath: "/file1", Into: testArray)
		
		let request = self.userAction.fetchRequest()
		
		do {
			try testArray = context.fetch(request)
		} catch {
			print("FAILED")
		}
		
		XCTAssertTrue(testArray.contains(file!), "Test array should contain the specified file")
	}
	
	func testDeleteFolder() {
		let context = self.setupInMemoryManagedObjectContext()
		var testArray = [NSManagedObject]()
		
		let folder = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		
		folder?.filePath = "/folder1/"
		folder?.name = "folder1"
		folder?.level = 0
		folder?.isFolder = true
		
		do {
			try context.save()
		} catch {
			print("FAILED")
		}
		
		context.delete(folder!)
		
		let request = self.userAction.fetchRequest()
		
		do {
			try testArray = context.fetch(request)
		} catch {
			print("FAILED")
		}
		
		XCTAssertFalse(testArray.contains(folder!), "Test array should not contain the specified folder")
	}
	
	func testDeleteFile() {
		let context = self.setupInMemoryManagedObjectContext()
		var testArray = [NSManagedObject]()
		
		let file = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item
		
		file?.filePath = "/file1"
		file?.name = "file1"
		file?.level = 0
		file?.isFolder = false
		
		do {
			try context.save()
		} catch {
			print("FAILED")
		}
		
		context.delete(file!)
		
		let request = self.userAction.fetchRequest()
		
		do {
			try testArray = context.fetch(request)
		} catch {
			print("FAILED")
		}
		
		XCTAssertFalse(testArray.contains(file!), "Test array should not contain the specified folder")
	}
	
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
		
		// delete everything in coredata
		let context = self.setupInMemoryManagedObjectContext()
		let fetch = NSFetchRequest<Item>.init(entityName: "Item")
		
		var testArray = [NSManagedObject]()
		
		do {
			try testArray = context.fetch(fetch)
		} catch {
			print("Error")
		}
		
		if testArray.count > 0 {
			for item in testArray {
				context.delete(item)
			}
		}
		
		do {
			try context.save()
		} catch {
			print("FAILED")
		}
		
    }
	
	func setupInMemoryManagedObjectContext() -> NSManagedObjectContext {
		let managedObjectModel = NSManagedObjectModel.mergedModel(from: [.main])!
		let persistentContainer = NSPersistentContainer.init(name: "SimpleFi", managedObjectModel: managedObjectModel)
		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		
		return persistentContainer.viewContext
	}
}
