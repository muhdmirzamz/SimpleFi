//
//  Item+CoreDataProperties.swift
//  SimpleFi
//
//  Created by Muhd Mirza on 25/12/16.
//  Copyright © 2016 muhdmirzamz. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var filePath: String?
    @NSManaged public var name: String?
    @NSManaged public var level: Int16
    @NSManaged public var isFolder: Bool

}
