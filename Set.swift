//
//  Set.swift
//  FlashCard
//
//  Created by Ruth Lin on 2015-09-18.
//  Copyright (c) 2015 Ruth Lin. All rights reserved.
//

import Foundation
import CoreData

class Set: NSManagedObject {

    @NSManaged var setName: String
    @NSManaged var setDescription: String
    @NSManaged var card1s: NSSet

        func addingCard1(value: Card) {
            self.mutableSetValueForKey("cards").addObject(value)
        }
    
}
