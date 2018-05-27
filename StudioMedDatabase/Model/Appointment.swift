//
//  Appointment.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import Contacts

//class Appointment {
//    var isCancelled: Bool
//    var date: String
//    var time: String
//    var firstName: String
//    var lastName: String
//    var phoneNumber: String
//    var email: String
//    var treatment1: String
//    var treatment2: String
//    var treatment3: String
//    var notes: String
//    var location: String
//    
//    init(isCancelledBool: Bool, firstNameText: String, lastNameText: String, phoneNumberText: String, emailText: String, dateText: String, timeText: String, treatment1Text: String, treatment2Text: String, treatment3Text: String, notesText: String, locationText: String) {
//        isCancelled = isCancelledBool
//        date = dateText
//        time = timeText
//        firstName = firstNameText
//        lastName = lastNameText
//        phoneNumber = phoneNumberText
//        email = emailText
//        treatment1 = treatment1Text
//        treatment2 = treatment2Text
//        treatment3 = treatment3Text
//        notes = notesText
//        location = locationText
//    }
//}

class AppointmentData : NSObject {
    public var isCancelled: Bool?
    public var firebaseUID: String?
    public var date: String?
    public var time: String?
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var email: String?
    public var treatment1: String?
    public var treatment2: String?
    public var treatment3: String?
    public var notes: String?
    public var location: String?
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> AppointmentData {
        struct Singleton {
            static var sharedInstance = AppointmentData()
        }
        return Singleton.sharedInstance
    }
    
}


class ApptArray : NSObject {
    public var listOfAppts : [AppointmentData] = []
    
    static let sharedInstance = ApptArray()
}
