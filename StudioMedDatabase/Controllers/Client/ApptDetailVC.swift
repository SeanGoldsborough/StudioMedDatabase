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
    var statusVarString = String()

    @IBAction func viewNotesButton(_ sender: Any) {
        
        let clientViewNotesVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientViewNotesVC") as! ClientViewNotesVC
        //clientViewNotesVC.notesTextView.text = apptObjectShared.notes ?? "No Notes Written."
        navigationController?.pushViewController(clientViewNotesVC, animated: true)
    }
    @IBAction func cancelApptButton(_ sender: Any) {
        print("cancel appt button pressed")
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let isCancelled = true
        let isActive = false
        let isComplete = false
        let uid = self.userObjectShared.fireBaseUID
        let date = self.apptObjectShared.date!
        let treatment = self.apptObjectShared.treatment1!
        let notes = self.apptObjectShared.notes ?? ""
        let clientKey = ref.child(uid!).key
        let clientApptKey = self.apptObjectShared.firebaseApptID!
        //let clientApptKey = ref.child(date).key
        let fullName = self.userObjectShared.firstName! + " " + self.userObjectShared.lastName!
        let adminKey = ref.child("\(fullName)").childByAutoId().key
        
        let post = ["firebaseApptID": clientApptKey,"firebaseClientID": uid, "isCancelled": isCancelled, "isActive": isActive, "isComplete": isComplete, "date": "\(date)", "firstName": "\(self.userObjectShared.firstName!)",
            "lastName": "\(self.userObjectShared.lastName!)",
            "phoneNumber": "\(self.userObjectShared.phoneNumber!)",
            "email": "\(self.userObjectShared.email!)", "treatment1": "\(treatment)", "notes": "\(notes)"] as [String : Any]
        let clientChildUpdates = ["/client/clients/\(clientKey)/appointments/\(clientApptKey)": post]
        let adminChildUpdates = ["/admin/appts/allAppts/\(clientApptKey)": post]
        ref.updateChildValues(clientChildUpdates)
        ref.updateChildValues(adminChildUpdates)
        
        print("user id is: \(userID).")
        
        //AlertView.alertPopUpTwo(view: self, title: "Appointment has been canceled!", alertMessage: "", buttonTitle: "OK")
        AlertView.apptCancelAlert(view: self, alertTitle: "Appointment has been canceled!", alertMessage: "")
        apptObjectShared.isCancelled = true
        apptObjectShared.isActive = false
        apptObjectShared.isComplete = false
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
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let isCancelled = false
        let isActive = true
        let isComplete = false
        let uid = self.userObjectShared.fireBaseUID
        let date = self.apptObjectShared.date!
        let treatment = self.apptObjectShared.treatment1!
        let notes = self.apptObjectShared.notes ?? ""
        let clientKey = ref.child(uid!).key
        let clientApptKey = ref.childByAutoId().key
        //let clientApptKey = ref.child(date).key
        let fullName = self.userObjectShared.firstName! + " " + self.userObjectShared.lastName!
        let adminKey = ref.child("\(fullName)").childByAutoId().key
//        let post = ["isCancelled": isCancelled, "date": "\(date)", "firstName": "\(self.userObjectShared.firstName!)",
//            "lastName": "\(self.userObjectShared.lastName!)",
//            "phoneNumber": "\(self.userObjectShared.phoneNumber!)",
//            "email": "\(self.userObjectShared.email!)", "treatment1": "\(treatment)", "notes": "\(notes)"] as [String : Any]
        
        let post = ["firebaseApptID": clientApptKey,"firebaseClientID": uid, "isCancelled": isCancelled, "isActive": isActive, "isComplete": isComplete, "date": "\(date)", "firstName": "\(self.userObjectShared.firstName!)",
            "lastName": "\(self.userObjectShared.lastName!)",
            "phoneNumber": "\(self.userObjectShared.phoneNumber!)",
            "email": "\(self.userObjectShared.email!)", "treatment1": "\(treatment)", "notes": "\(notes)"] as [String : Any]
        let clientChildUpdates = ["/client/clients/\(clientKey)/appointments/\(clientApptKey)": post]
        let adminChildUpdates = ["/admin/appts/allAppts/\(clientApptKey)": post]
        ref.updateChildValues(clientChildUpdates)
        ref.updateChildValues(adminChildUpdates)
        
        print("user id is: \(userID).")
   
        apptObjectShared.isCancelled = false
        apptObjectShared.isActive = true
        apptObjectShared.isComplete = false
        apptObjectShared.firebaseApptID = clientApptKey
        
        
        AlertView.apptCreateAlert(view: self, alertTitle: "Appointment request has been created!", alertMessage: "A member of the StudioMed staff will be in contact shortly to confirm.")
        
        //rateAppAlert()
    }
    
    @IBOutlet weak var apptStatusLabel: UILabel!
    @IBOutlet weak var apptDateAndTimeLabel: UILabel!
    @IBOutlet weak var treatmentLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("colored index is \(coloredCellIndex)")
        print("user email is \(userObjectShared.email!)")
        navigationController?.navigationBar.isHidden = false
        
        var date = self.apptDateAndTimeLabel.text
        var treatment = self.treatmentLabel.text
        
        date = apptObjectShared.date!
        treatment = apptObjectShared.treatment1!
        
        let activeAttributes: [NSAttributedStringKey: Any] =
            [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 24)!,
             NSAttributedStringKey.strikethroughStyle: 0]
        
        let cancelledAttributes: [NSAttributedStringKey: Any] =
            [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 17)!,
             NSAttributedStringKey.strikethroughStyle: 1]
        
        let completeAttributes: [NSAttributedStringKey: Any] =
            [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 17)!,
             NSAttributedStringKey.strikethroughStyle: 0]

        if self.apptObjectShared.isCancelled == true {
            
            self.apptDateAndTimeLabel.attributedText = NSAttributedString(string: date!, attributes: cancelledAttributes)
            self.apptDateAndTimeLabel.textColor = UIColor(rgb: 0xFF6666)
            
            self.treatmentLabel.attributedText = NSAttributedString(string: treatment!, attributes: cancelledAttributes)
            self.treatmentLabel.textColor = UIColor(rgb: 0xFF6666)
            
        } else if self.apptObjectShared.isCancelled == false && self.apptObjectShared.isActive == true {
            
            self.apptDateAndTimeLabel.attributedText = NSAttributedString(string: date!, attributes: activeAttributes)
            self.apptDateAndTimeLabel.textColor = UIColor.green
            
            self.treatmentLabel.attributedText = NSAttributedString(string: treatment!, attributes: activeAttributes)
            self.treatmentLabel.textColor = UIColor.green
            
        } else if self.apptObjectShared.isCancelled == false && self.apptObjectShared.isActive == false {
            
            apptDateAndTimeLabel.attributedText = NSAttributedString(string: date!, attributes: completeAttributes)
            
            treatmentLabel.attributedText = NSAttributedString(string: treatment!, attributes: completeAttributes)
        }
        
//        self.apptStatusLabel.text = "Appointment is: \(statusVarString)"
        self.apptDateAndTimeLabel.text = apptObjectShared.date!
        self.treatmentLabel.text = apptObjectShared.treatment1!

        self.userFullNameLabel.text = userObjectShared.firstName! + " " + userObjectShared.lastName!
        self.userPhoneLabel.text = userObjectShared.phoneNumber!
        self.userEmailLabel.text = userObjectShared.email!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
