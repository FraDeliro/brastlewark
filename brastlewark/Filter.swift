//
//  Filter.swift
//  virail
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 PED. All rights reserved.
//

import UIKit

enum FilterType: Int {
    case Active
    case InActive

}

enum OrderType: Int {
    case Age
    case Name
}


class Filter: NSObject {
    
    static let shared = Filter(type: .InActive)
    var type: FilterType?
    var baseOrder: OrderType?
    var ageLowerValue: Int?
    var ageUpperValue: Int?
    var heightLowerValue: Int?
    var heightUpperValue: Int?
    var weightLowerValue: Int?
    var weightUpperValue: Int?
   
    
    init(type: FilterType) {
        self.type = type
    }
    
    func setFilter(baseOrder: OrderType, ageLowerValue: Int, ageUpperValue: Int, heightLowerValue: Int, heightUpperValue: Int, weightLowerValue: Int, weightUpperValue: Int) {
        
    UserDefaults.standard.set(self.type?.rawValue, forKey: "FilterActive")
        switch self.type?.rawValue ?? 0 {
        case 0:
            UserDefaults.standard.set(baseOrder.rawValue, forKey: "BaseOrder")
            UserDefaults.standard.set(ageLowerValue, forKey: "AgeLowerValue")
            UserDefaults.standard.set(ageUpperValue, forKey: "AgeUpperValue")
            UserDefaults.standard.set(heightLowerValue, forKey: "HeightLowerValue")
            UserDefaults.standard.set(heightUpperValue, forKey: "HeightUpperValue")
            UserDefaults.standard.set(weightLowerValue, forKey: "WeightLowerValue")
            UserDefaults.standard.set(weightUpperValue, forKey: "WeightUpperValue")
        case 1: break
        default: break
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func removeSavedFilters() {
    
        UserDefaults.standard.set(1, forKey: "FilterActive")
        UserDefaults.standard.removeObject(forKey: "BaseOrder")
        UserDefaults.standard.removeObject(forKey: "AgeLowerValue")
        UserDefaults.standard.removeObject(forKey: "AgeUpperValue")
        UserDefaults.standard.removeObject(forKey: "HeightLowerValue")
        UserDefaults.standard.removeObject(forKey: "HeightUpperValue")
        UserDefaults.standard.removeObject(forKey: "WeightLowerValue")
        UserDefaults.standard.removeObject(forKey: "WeightUpperValue")
       
        UserDefaults.standard.synchronize()
    }
    
    func getSavedFilter() -> Filter {
        
        let savedFilter = Filter(type: FilterType.Active)
        
        savedFilter.baseOrder = OrderType(rawValue:UserDefaults.standard.integer(forKey: "BaseOrder"))
         savedFilter.ageLowerValue = UserDefaults.standard.integer(forKey: "AgeLowerValue")
         savedFilter.ageUpperValue = UserDefaults.standard.integer(forKey: "AgeUpperValue")
         savedFilter.heightLowerValue = UserDefaults.standard.integer(forKey: "HeightLowerValue")
         savedFilter.heightUpperValue = UserDefaults.standard.integer(forKey: "HeightUpperValue")
        savedFilter.weightLowerValue = UserDefaults.standard.integer(forKey: "WeightLowerValue")
        savedFilter.weightUpperValue = UserDefaults.standard.integer(forKey: "WeightUpperValue")

        return savedFilter
    }
    
}
