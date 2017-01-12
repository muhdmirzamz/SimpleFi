//
//  UserAction.swift
//  SimpleTodo
//
//  Created by Muhd Mirza on 6/12/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class UserAction {
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	var validator = Validator()
	
	func fetchRequest(WithFilePath filePath: String, AndLevel level: Int) -> [NSManagedObject] {
		var itemsArray = [NSManagedObject]()
		
		do {
			let request = NSFetchRequest<Item>(entityName: "Item")
			request.predicate = NSPredicate.init(format: "filePath contains %@ AND level = %i", filePath, level)
			itemsArray = try self.context.fetch(request)
			
			print("filePath: \(filePath)")
			
			for object in itemsArray {
				if let iteratedItem = object as? Item {
					if self.validator.item(iteratedItem, hasIncorrectParentPathComparedTo: filePath) {
						itemsArray.remove(at: itemsArray.index(of: iteratedItem)!)
					}
				}
			}
		} catch {
			print("FAILED")
		}
		
		return itemsArray
	}
	
	func fetchRequest() -> NSFetchRequest<Item> {
		return NSFetchRequest<Item>(entityName: "Item")
	}
	
	// for normal use
	func addItem(WithName itemEntry: String, AndLevel level: Int, AndIsFolder isFolder: Bool, AtFilePath filePath: String, Into itemsArray: [NSManagedObject]) -> [NSManagedObject] {
		var itemsArray = itemsArray
		
		// add it to the context
		let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: self.context) as? Item
		item?.name = itemEntry
		item?.level = Int16(level)
	
		if isFolder {
			item?.filePath = filePath + itemEntry + "/"
			item?.isFolder = true
		} else {
			item?.filePath = filePath + itemEntry
			item?.isFolder = false
		}
		
		do {
			try self.context.save()
			
			itemsArray.append(item!)
		} catch {
			print("FAILED")
		}
		
		return itemsArray
	}
	
	func delete(item: Item) {
		if item.isFolder {
			do {
				let request: NSFetchRequest<Item> = self.fetchRequest()
				
				let itemsArray = try self.context.fetch(request)
				
				for iteratedItem in itemsArray {
					// check for filePath of the folder you are deleting
					// if you just use self.filePath
					// that is the directory you are in
					// not the folder you want to delete
					if (iteratedItem.filePath?.contains(item.filePath!))! {
						// hard to remove from itemsArray here because indexes are messed up
						self.context.delete(iteratedItem)
					}
				}
			} catch {
				print("FAILED")
			}
		} else {
			self.context.delete(item)
		}
		
		do {
			try self.context.save()
		} catch {
			print("FAILED")
		}
	}
}
