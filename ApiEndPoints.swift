//
//  ApiEndPoints.swift
//  xroads
//
//  Created by Abdul on 07/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit

public class ApiEndPoints {
    
    public var upcomingTripEndPoint: String? = "https://4590980c.ngrok.io/xroads-app/trip/champion?id="
    public var registrationEndPoint: String? = "http://4590980c.ngrok.io/xroads-app/user"
    //public var loginEndPoint: String? = "http://10.106.30.102:8080/xroads-app-0.0.1-SNAPSHOT/user/validate"
    public var loginEndPoint: String? = "https://4590980c.ngrok.io/xroads-app/user/validate"
    public var createTrip: String? = "https://4590980c.ngrok.io/xroads-app/user/trip"
    
    init()
    {
        
    }
    
}
