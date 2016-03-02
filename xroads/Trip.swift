//
//  Trips.swift
//  xroads
//
//  Created by Abdul on 02/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit

struct Trip {
    var tripName: String?
    var tripId: Int
    var tripStartPlace: String?
    
    init(tripName: String?, tripId: Int, tripStartPlace: String?) {
        self.tripName = tripName
        self.tripId = tripId
        self.tripStartPlace = tripStartPlace
    }
}