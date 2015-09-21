//
//  Card1.swift
//  FlashCard
//
//  Created by Ruth Lin on 2015-09-18.
//  Copyright (c) 2015 Ruth Lin. All rights reserved.
//

import Foundation
import CoreData

class Card1: Set {
    @NSManaged var back: String
    @NSManaged var front: String
    @NSManaged var photo: AnyObject
    @NSManaged var aset: Set
}
