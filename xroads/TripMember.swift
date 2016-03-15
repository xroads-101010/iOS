//
//  TripMember.swift
//  xroads
//
//  Created by Abin Anto on 14/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit

class TripMember {
    
    var memberId: Int?
    var memberName: String?
    var tripId: Int?
    var memberStartingLocation: String?
    var memberStartingLocationLat: String?
    var memberStartingLocationLong: String?
    var hasMemberJoined: Bool?
    var currentLocation: String?
    var currentLocationLat: String?
    var currentLocationLong: String?
    
    init(json: NSDictionary)
    {
        self.memberId = json["memberId"] as? Int
        self.memberName = json["memberName"] as? String
        self.tripId = json["tripId"] as? Int
        self.memberStartingLocation = json["memberStartingLocation"] as? String
        self.memberStartingLocationLat = json["memberStartingLocationLat"] as? String
        self.memberStartingLocationLong = json["memberStartingLocationLong"] as? String
        self.hasMemberJoined = json["hasMemberJoined"] as? Bool
        self.currentLocation = json["currentLocation"] as? String
        self.currentLocationLat = json["currentLocationLat"] as? String
        self.currentLocationLong = json["currentLocationLong"] as? String
    }
}
