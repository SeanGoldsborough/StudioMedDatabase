//
//  Appointment.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import Contacts

class Appointment {
    var firebaseApptID: String
    var firebaseClientID: String
    var isCancelled: Bool
    var isActive: Bool
    var isComplete: Bool
    var date: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var treatment1: String
    var notes: String
    
    init(firebaseApptIDString: String, firebaseClientIDString: String, isCancelledBool: Bool, isActiveBool: Bool, isCompleteBool: Bool, firstNameText: String, lastNameText: String, phoneNumberText: String, emailText: String, dateText: String, treatment1Text: String,  notesText: String) {
        firebaseApptID = firebaseApptIDString
        firebaseClientID = firebaseClientIDString
        isCancelled = isCancelledBool
        isActive = isActiveBool
        isComplete = isCompleteBool
        date = dateText
        firstName = firstNameText
        lastName = lastNameText
        phoneNumber = phoneNumberText
        email = emailText
        treatment1 = treatment1Text
        notes = notesText
    }
}

class NewAppointment : NSObject {
    
    public var firebaseApptID: String?
    public var firebaseClientID: String?
    public var isCancelled: Bool?
    public var isActive: Bool?
    public var isComplete: Bool?
    public var date: String?
    public var time: String?
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var email: String?
    public var treatment1: String?
    public var notes: String?
   
        class func sharedInstance() -> NewAppointment {
            struct Singleton {
                static var sharedInstance = NewAppointment()
            }
            return Singleton.sharedInstance
        }
}

class NewAppointmentData : NSObject {
    public var firebaseApptID: String?
    public var firebaseClientID: String?
    public var isCancelled: Bool?
    public var isActive: Bool?
    public var isComplete: Bool?
    public var date: String?
    public var time: String?
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var email: String?
    public var treatment1: String?
    public var notes: String?
 
    // MARK: Shared Instance
    
    struct Singleton {
        static var sharedInstance: NewAppointmentData?
    }
    
    class var sharedInstance: NewAppointmentData {
        if Singleton.sharedInstance == nil {
            Singleton.sharedInstance = NewAppointmentData()
            print("init a singleton shared instance")
        }
        return Singleton.sharedInstance!
    }
    
    class func dispose() {
        NewAppointmentData.Singleton.sharedInstance = nil
        print("Disposed AppointmentData Singleton sharedInstance")
        print(NewAppointmentData.sharedInstance)
    }
}

class AppointmentData : NSObject {
    public var firebaseApptID: String?
    public var firebaseClientID: String?
    public var isCancelled: Bool?
    public var isActive: Bool?
    public var isComplete: Bool?
    public var date: String?
    public var time: String?
    public var firstName: String?
    public var lastName: String?
    public var phoneNumber: String?
    public var email: String?
    public var treatment1: String?
    public var notes: String?
 
    // MARK: Shared Instance
    
    struct Singleton {
        static var sharedInstance: AppointmentData?
    }
    
    class var sharedInstance: AppointmentData {
        if Singleton.sharedInstance == nil {
            Singleton.sharedInstance = AppointmentData()
            print("init a singleton shared instance")
        }
        return Singleton.sharedInstance!
    }
    
    class func dispose() {
        AppointmentData.Singleton.sharedInstance = nil
        print("Disposed AppointmentData Singleton sharedInstance")
        print(AppointmentData.sharedInstance)
    }
}


class ApptArray : NSObject {
    public var listOfAppts : [AppointmentData] = []
    
    static let sharedInstance = ApptArray()
}

