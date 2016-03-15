//
//  AllUsersModel.swift
//  xroads
//
//  Created by Abdul on 11/03/16.
//  Copyright © 2016 lister. All rights reserved.
//

import UIKit

class AllUsersModel {
    
    var userName: String?
    var userMobile: Int?
    var email: String?
    var isRegistered: Bool?
    var userId: Int?
    var createdAt: Double?
    var updatedAt: Double?
    
    class var sharedManager: UserModel {
        struct Static {
            static let instance = UserModel()
        }
        return Static.instance
    }
    
    init(json: NSDictionary)
    {
        self.userName = json["userName"] as? String
        self.userMobile = json["userMobile"] as? Int
        self.email = json["email"] as? String
        self.isRegistered = json["isRegistered"] as? Bool
        self.userId = json["id"] as? Int
        self.createdAt = json["createdAt"] as? Double
        self.updatedAt = json["updatedAt"] as? Double
    }
}