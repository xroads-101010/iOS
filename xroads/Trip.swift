//
//  Trips.swift
//  xroads
//
//  Created by Abdul on 02/03/16.
//  Copyright © 2016 lister. All rights reserved.
//
import UIKit

class Trip {
    
    var tripName: String?
    var tripDestination: String?
    var tripChampion: Int?
    var hasTripStarted: Bool?
    var startTime: Double?
    var endTime: Double?
    var createdAt: Double?
    var updatedAt: Double?
    
    init(json: NSDictionary)
    {
        self.tripName = json["tripName"] as? String
        self.tripDestination = json["tripDestination"] as? String
        self.tripChampion = json["tripChampion"] as? Int
        self.hasTripStarted = json["hasTripStarted"] as? Bool
        self.startTime = json["startTime"] as? Double
        self.endTime = json["endTime"] as? Double
        self.createdAt = json["createdAt"] as? Double
        self.updatedAt = json["updatedAt"] as? Double
    }
}