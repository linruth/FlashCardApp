//
//  Card.swift
//  
//
//  Created by Ruth Lin on 2015-09-15.
//
//

import Foundation
import CoreData

class CardSet: NSManagedObject {

    @NSManaged var back: String
    @NSManaged var front: String
    @NSManaged var photo: NSData
    @NSManaged var setDescription: String
    @NSManaged var setName: String

}
