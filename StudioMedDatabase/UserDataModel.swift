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

// MARK: Shared Instance

//struct UserData {
//
//    public var firstName : String?
//    public var lastName : String?
//    public var phoneNumber : String?
//    public var email : String?
//    public var password : String?
//
//    init?(dictionary: [String:AnyObject]) {
//        firstName = dictionary["firstName"] as? String ?? "[No First Name]"
//        lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
//        phoneNumber = dictionary["phoneNumber"] as? String ?? "No Map String"
//        email = dictionary["email"] as? String ?? "[No URL]"
//        password = dictionary["self.password"] as? String ?? "no value"
//    }
//
//    static func usersFromResults(_ results: [[String:AnyObject]]) -> [UserData] {
//        var users = [UserData]()
//        var userList = StudentArray.sharedInstance.listOfUsers
//        // iterate through array of dictionaries, each Object is a dictionary
//        for result in results {
//            users.append(UserData(dictionary: result)!)
//            userList.append(UserData(dictionary: result)!)
//        }
//        return users
//    }
//}



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
