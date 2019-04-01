//
//  Avatar.swift
//  SFR-Shell
//
//  Created by Vikesh JOYPAUL on 06/02/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import Foundation


// Mark: - Avatar with accessory
public struct Avatar {
    var name: String
    var accessories: [Accessories]
    var model: String
    var icon: String
    var category: Category
    var scaleFactor: Float
    
    init(name: String, accessories:[Accessories], model: String,
         icon: String, category: Category, scaleFactor: Float) {
        self.name = name
        self.accessories = accessories
        self.model = model
        self.icon = icon
        self.category = category
        self.scaleFactor = scaleFactor
    }
}

// Mark: - List of Accessories classified as Category
public enum Category: String {
    
    case hats, sunglasses, eyerings, moustaches, hairs, avatar, all
    
    //return raw value
    public var description: String {
        return self.rawValue
    }
}

// MARK: - Accessories
public struct Accessories {
    var accesory: [Accessory]
    var icon: String
    var title: String
    init(accesory: [Accessory], icon: String, title: String) {
        self.accesory = accesory
        self.icon = icon
        self.title = title
    }
}

// Mark: - Sing Accessory
public struct Accessory {
    var name: String
    var model: String
    var category: Category
    var icon: String
    
    init(name: String, model: String, category: Category, icon: String) {
        self.name = name
        self.model = model
        self.category = category
        self.icon = icon
    }
}
