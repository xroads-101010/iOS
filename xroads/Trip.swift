//
//  Trips.swift
//  xroads
//
//  Created by Abdul on 02/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

/*import UIKit

struct Trip {
    var tripName: String?
    var tripId: Int
    var tripStartPlace: String?
    
    /*init(tripName: String?, tripId: Int, tripStartPlace: String?) {
        self.tripName = tripName
        self.tripId = tripId
        self.tripStartPlace = tripStartPlace
    }*/
    
    init(json: NSDictionary) {
        self.tripName = json["name"] as? String
        self.tripId = 005
        self.tripStartPlace = json["html_url"] as? String
    }
}*/


import UIKit

class Trip {
    
    var tripName: String?
    var tripDestination: String?
    var tripChampion: String?
    var hasTripStarted: String?
    var startTime: String?
    var endTime: String?
    var createdAt: String?
    var updatedAt: String?
    
    init(json: NSDictionary)
    {
        self.tripName = json["tripName"] as? String
        self.tripDestination = json["tripDestination"] as? String
        self.tripChampion = json["tripChampion"] as? String
        self.hasTripStarted = json["hasTripStarted"] as? String
        self.startTime = json["startTime"] as? String
        self.endTime = json["endTime"] as? String
        self.createdAt = json["createdAt"] as? String
        self.updatedAt = json["updatedAt"] as? String
    }
}