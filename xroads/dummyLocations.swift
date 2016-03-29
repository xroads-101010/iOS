//
//  dummyLocations.swift
//  xroads
//
//  Created by Abin Anto on 28/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit
import GoogleMaps

class dummyLocations {
    
    var routeOne: [Int: String]

    class var sharedManager: dummyLocations {
        struct Static {
            static let instance = dummyLocations()
        }
        return Static.instance
    }
    
    init()
    {
        self.routeOne = [1: "12.970365,80.2429693", 2: "12.971578,80.2426903", 3: "12.973803,80.2421643", 4: "12.975831,80.2416813", 5: "12.979843,80.2410073", 6: "12.981275,80.2418443", 7: "12.981139,80.2426273", 8: "12.980836,80.2453523", 9: "12.980136,80.2494503", 10: "12.98207,80.2503303", 11: "12.985578,80.2497583", 12: "12.987959,80.2502713"]
    }
}
