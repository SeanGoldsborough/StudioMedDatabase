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
    
    
    class func apptAlert(view: UIViewController, alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        let addAppt = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            view.navigationController?.popViewController(animated: true)
//            let addLocationNavVC = view.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavCont")
//            addLocationNavVC.modalTransitionStyle = .crossDissolve
//            view.present(addLocationNavVC, animated: true, completion: nil)
            
            
        })
        alert.addAction(addAppt)
        //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}
