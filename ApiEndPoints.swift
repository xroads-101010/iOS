//
//  ApiEndPoints.swift
//  xroads
//
//  Created by Abdul on 07/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit

public class ApiEndPoints {
    
    public var upcomingTripEndPoint: String? = "https://d4d55a60.ngrok.io/xroads-app/trip/all?userId="
    public var registrationEndPoint: String? = "https://d4d55a60.ngrok.io/xroads-app/user"
    //public var loginEndPoint: String? = "http://10.106.30.102:8080/xroads-app-0.0.1-SNAPSHOT/user/validate"
    public var loginEndPoint: String? = "https://d4d55a60.ngrok.io/xroads-app/user/validate"
    public var createTrip: String? = "https://d4d55a60.ngrok.io/xroads-app/trip"
    public var allMembersEndPoint: String? = "https://d4d55a60.ngrok.io/xroads-app/user/allUsers"
    public var updateUserLocation: String? = "https://d4d55a60.ngrok.io/xroads-app/location"
    
    init()
    {
        
    }
    
}
