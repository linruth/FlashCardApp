//
//  FlashCard.swift
//  FlashCard
//
//  Created by Ruth Lin on 2015-09-18.
//  Copyright (c) 2015 Ruth Lin. All rights reserved.
//

import UIKit

class Card  {
    
    // MARK: Properties
    
     var setName: String
     var setDescription: String?
     var front: String
     var photo: UIImage?
     var back: String
    

    // MARK: Initialization
    
    init?(setName: String, setDescription: String?, front: String, photo: UIImage?, back: String) {
        self.setName = setName
        self.setDescription = setDescription
        self.front = front
        self.photo = photo
        self.back = back
        // Initialization should fail if there is no setName, front, or back
        if setName.isEmpty || front.isEmpty || back.isEmpty {
            return nil
        }
        
    }
    
}
