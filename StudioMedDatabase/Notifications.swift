//
//  Notifications.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/28/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AudioToolbox
import _SwiftUIKitOverlayShims
import UserNotifications

class Notifications {
    
    class func adminNotification() {
//        if userNameTF.text == "" || passwordTF.text == "" {
//            sender.shake()
//            userNameTF.shakeTF()
//            passwordTF.shakeTF()
//            //AudioServicesPlaySystemSound(1514)
//            tapped()
//            let timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { (timer) in
//                AlertView.alertMessage(view: self, title: "ERROR", message: "Invalid Credentials", numberOfButtons: 0, leftButtonTitle: "Try Again", leftButtonStyle: 0, rightButtonTitle: "", rightButtonStyle: 0)
//            }
//        } else {
//            print("Credentials Are Valid")
//        }
        let adminID = Auth.auth().currentUser?.uid
        
       // if adminID == "ks5xtiGRZNWfaVvgAtK9zHWekru1" {
            let content = UNMutableNotificationContent()
            content.title = "NEW APPOINTMENT REQUESTED"
            content.subtitle = "Check Appointments List"
            //content.body = "Schedule your appointment today!"
            content.badge = 1
            //content.sound = UNNotificationSound.default()
            content.sound = UNNotificationSound(named: "CustomNotificationSound5.5.wav")
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let request = UNNotificationRequest(identifier: "timer done", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            AudioServicesPlaySystemSound(1521)
            
       // }
    }
    
}
