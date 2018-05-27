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
        //getUserData()
//        if tabBarItem.selectedImage
//        tabBarItem.badgeColor = UIColor.darkGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getUserData() {
//        databaseHandle = ref.child("client").child("clients").child(currentUser!).observe(.childAdded, with: { (snapshot) in
//            if let userDict = snapshot.value as? [String : AnyObject] {
//                print("userDict is \(userDict)")
//
//                let firstNameText = userDict["firstName"] as! String
//                let lastNameText = userDict["lastName"] as! String
//                let phoneNumberText = userDict["phoneNumber"] as! String
//                let zipCodeText = userDict["zipCode"] as! String
//                let emailText = userDict["email"] as! String
//
//                self.userObjectShared.fireBaseUID = self.currentUser!
//                self.userObjectShared.firstName = firstNameText
//                self.userObjectShared.lastName = lastNameText
//                self.userObjectShared.phoneNumber = phoneNumberText
//                self.userObjectShared.zipCode = zipCodeText
//                self.userObjectShared.email = Auth.auth().currentUser?.email!
//
//                print("userDict is \(self.userObjectShared.fireBaseUID)")
//                print("userDict is \(self.userObjectShared.firstName)")
//                print("userDict is \(self.userObjectShared.lastName)")
//                print("userDict is \(self.userObjectShared.phoneNumber)")
//                print("userDict is \(self.userObjectShared.zipCode)")
//                print("userDict is \(self.userObjectShared.email)")
//            }
//        })
//    }
    
    
}


