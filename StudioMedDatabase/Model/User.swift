//
//  User.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
class User {
    var firebaseUID: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var zipCode: String
    
    init(firebaseUIDText: String, firstNameText: String, lastNameText: String, phoneNumberText: String, emailText: String, zipCodeText: String) {
        firebaseUID = firebaseUIDText
        firstName = firstNameText
        lastName = lastNameText
        phoneNumber = phoneNumberText
        email = emailText
        zipCode = zipCodeText
    }
}
