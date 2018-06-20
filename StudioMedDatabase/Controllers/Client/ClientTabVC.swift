//
//  ClientTabVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ClientTabVC: UITabBarController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var userObjectShared = UserData.sharedInstance()
    var currentUser = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
}


