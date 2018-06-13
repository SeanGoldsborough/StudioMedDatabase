//
//  Alerts.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

class AlertView {

    class func alertPopUp(view: UIViewController, alertMessage: String) {
        let alert = UIAlertController(title: "ERROR", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
        
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    class func alertPopUpTwo(view: UIViewController, title: String, alertMessage: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    class func apptCancelAlert(view: UIViewController, alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        var apptObjectShared = AppointmentData.sharedInstance
        apptObjectShared.date = "Select A Date & Time"
        apptObjectShared.time = ""
        apptObjectShared.treatment1 = "Select A Treatment"
        apptObjectShared.notes = "Add A Note For The Doctor"
      
        let addAppt = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let createApptVC = view.storyboard!.instantiateViewController(withIdentifier: "CreateApptVC")
            //createApptVC.
            view.navigationController?.popViewController(animated: true)
        })
        alert.addAction(addAppt)
        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
 
    class func apptCreateAlert(view: UIViewController, alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let tabBarController = UITabBarController()
        var apptObjectShared = AppointmentData.sharedInstance
        apptObjectShared.date = "Select A Date & Time"
        apptObjectShared.time = ""
        apptObjectShared.treatment1 = "Select A Treatment"
        apptObjectShared.notes = "Add A Note For The Doctor"
        
        print(" apptObjectShared.date is : \( apptObjectShared.date)")
       // Notifications.adminNotification()
        let addAppt = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

            tabBarController.selectedIndex = 2
            view.navigationController?.popViewController(animated: true)
   
        })
        alert.addAction(addAppt)
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
            
        }
    }
    
    class func addNewAdminAlert(view: UIViewController, alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let tabBarController = UITabBarController()
        
        //Notifications.adminNotification()
        let addAppt = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

            tabBarController.selectedIndex = 0
            view.navigationController?.popViewController(animated: true)
            
        })
        alert.addAction(addAppt)
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
            
        }
    }
}
