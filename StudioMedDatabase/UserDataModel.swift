//
//  UserDataModel.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class UserArray : NSObject {
    public var listOfUsers : [UserData] = []
    
    static let sharedInstance = UserArray()
}


class UserData : NSObject {
    
    public var fireBaseUID : String?
    public var firstName : String?
    public var lastName : String?
    public var phoneNumber : String?
    public var zipCode : String?
    public var email : String?
    public var password : String?
    public var allowNotifications : Bool?
    public var allowEmailNewsletter : Bool?
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UserData {
        struct Singleton {
            static var sharedInstance = UserData()
        }
        return Singleton.sharedInstance
    }
        
}
