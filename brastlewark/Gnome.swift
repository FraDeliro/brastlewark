//
//  Gnome.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Gender {
    case man
    case woman
}

class Gnome: NSObject {
    var gender: Gender?
    var id: Int?
    var name: String?
    var age: Int?
    var height: Int?
    var weight: Int?
    var hair_color: String?
    var thumbnail: String?
    var friends = [String]()
    var professions = [String]()
    
    init (id: Int, name: String, age: Int, height: Int, weight: Int, hair_color: String, thumbnail: String, friends: [String], professions: [String]) {
        self.id = id
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.hair_color = hair_color
        self.thumbnail = thumbnail
        self.friends = friends
        self.professions = professions
        
        let first_name = name.components(separatedBy: " ").first!
        switch (String(describing: first_name.characters.last!),hair_color) {
        case ("a",_):
            self.gender = .woman
        case ("e","Gray"):
            self.gender = .woman
        case (_,"Pink"):
            self.gender = .woman
        case ("o",_):
            self.gender = .man
        default:
            self.gender = .man
        }
    }
    
    class func getGnomeWithJSON(modelDict: JSON) -> Gnome {
        
        let id = modelDict["id"].intValue
        let name = modelDict["name"].stringValue
        let age = modelDict["age"].intValue
        let height = modelDict["height"].intValue
        let weight = modelDict["weight"].intValue
        let hair_color = modelDict["hair_color"].stringValue
        let thumbnail = modelDict["thumbnail"].stringValue
        let friends = modelDict["friends"].arrayObject
        let professions = modelDict["professions"].arrayObject
        
        let gnome = Gnome(id: id, name: name, age: age, height: height, weight: weight, hair_color: hair_color, thumbnail: thumbnail, friends: friends as! [String], professions: professions as! [String])
        
        return gnome
        
    }
}
