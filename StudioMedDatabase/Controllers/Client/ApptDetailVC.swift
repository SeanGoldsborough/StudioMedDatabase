//
//  ApptDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ApptDetailVC: UIViewController {
    var coloredCellIndex = Int()
    var userObjectShared = UserData.sharedInstance()
    var apptObjectShared = AppointmentData.sharedInstance()

    @IBAction func cancelApptButton(_ sender: Any) {
        print("cancel appt button pressed")
        
        //AlertView.alertPopUpTwo(view: self, title: "Appointment has been canceled!", alertMessage: "", buttonTitle: "OK")
        AlertView.apptCancelAlert(view: self, alertTitle: "Appointment has been canceled!", alertMessage: "")
        apptObjectShared.isCancelled = true
//        var mainViewController:ClientAppointmentHistoryVC?
//
//        var zipBool = "0"
//
//        mainViewController?.coloredCellIndex = self.coloredCellIndex
//        print("colored index is \(self.coloredCellIndex)")
//        print("colored index is \(mainViewController?.coloredCellIndex)")
//        mainViewController?.selectedIndexes.append(self.coloredCellIndex)
        //mainViewController?.users[coloredCellIndex].phoneNumber = zipBool
        //mainViewController?.tableView.reloadData()
        //clientApptHistory.tableView.reloadData()
        
        //navigationController?.popViewController(animated: true)
        //navigationController?.pushViewController(clientApptHistory, animated: true)
        
        
    }
    
//    func rateAppAlert() {
//        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
//        if currentCount == 7 {
//            print("we launched the app more than 4 times")
//            AlertView.alertPopUp(view: self, alertMessage: "Rate the app!")
//        }
//    }

    
    
    @IBAction func confirmAppt(_ sender: Any) {
        //AlertView.alertPopUpTwo(view: self, title: "Appointment has been created!", alertMessage: "A member of the StudioMed staff will be in contact shortly to confirm.", buttonTitle: "OK")
        
        
        AlertView.apptCreateAlert(view: self, alertTitle: "Appointment has been created!", alertMessage: "A member of the StudioMed staff will be in contact shortly to confirm.")
        
        //rateAppAlert()
    }
    
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("colored index is \(coloredCellIndex)")
        print("user name is \(userObjectShared.email!)")
        navigationController?.navigationBar.isHidden = false
        self.userFullNameLabel.text = userObjectShared.firstName! + " " + userObjectShared.lastName!
        self.userPhoneLabel.text = userObjectShared.phoneNumber!
        self.userEmailLabel.text = userObjectShared.email!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
