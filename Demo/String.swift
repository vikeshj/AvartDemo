//
//  String.swift
//  SFR-Shell
//
//  Created by Vikesh JOYPAUL on 25/02/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//
import UIKit

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func replace(target: String, words: String) -> String {
        return self.replacingOccurrences(of: target, with: words)
    }
    
    var emotions: String {
        return  self.contains(find: "_R") ? self.replace(target: "_R", words: "Right") : (self.contains(find: "_L") ? self.replace(target: "_L", words: "Left") : self)
    }
    
}
