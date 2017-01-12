//
//  Validator.swift
//  SimpleTodo
//
//  Created by Muhd Mirza on 7/12/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import Foundation
import CoreData

public class Validator {
	func item(Named itemEntry: String, HasDuplicateInArray itemsArray: [NSManagedObject]) -> Bool {
		var duplicateFound = false
		
		for object in itemsArray {
			if let iteratedItem = object as? Item {
				if (iteratedItem.name)! == itemEntry {
					duplicateFound = true
					break;
				}
			}
		}
		
		return duplicateFound
	}
	
	func item(_ iteratedItem: Item, hasIncorrectParentPathComparedTo filePath: String) -> Bool {
		let itemPath = iteratedItem.filePath!
		var itemName = ""
		
		if iteratedItem.isFolder {
			itemName = iteratedItem.name! + "/"
		} else {
			itemName = iteratedItem.name!
		}
		
		let parentPath = self.getParentPathSubstringOf(itemPath: itemPath, withName: itemName)
		
		return parentPath != filePath
	}
	
	// helper function
	func getParentPathSubstringOf(itemPath: String, withName itemName: String) -> String {
		// use parent path length to get end of parent path index
		// use substring to get parent path
		let parentPathLength = itemPath.characters.count - itemName.characters.count
		let endOfParentPathIndex = itemPath.index(itemPath.startIndex, offsetBy: parentPathLength)
		
		let parentPath = itemPath.substring(to: endOfParentPathIndex)
		return parentPath
	}
}
