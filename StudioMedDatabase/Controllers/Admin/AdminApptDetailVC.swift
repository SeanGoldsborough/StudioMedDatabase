//
//  AdminApptDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class AdminApptDetailVC: UIViewController {
    
    @IBOutlet weak var apptStatusLabel: UILabel!
    var cancelledBool = false
    var completedBool = false
    var activeBool = true
    
    var coloredCellIndex = Int()
    var userObjectShared = UserData.sharedInstance()
    var apptObjectShared = AppointmentData.sharedInstance
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBAction func viewNotes(_ sender: Any) {
        let adminViewNotesVC = storyboard?.instantiateViewController(withIdentifier: "AdminViewNotes") as! AdminViewNotes
        //listOfAppointmentsVC.userName = fullName
        navigationController?.pushViewController(adminViewNotesVC, animated: true)
    }
    @IBOutlet weak var apptDateTime: UILabel!
    @IBOutlet weak var treatmentLabel: UILabel!
    @IBAction func cancelApptButton(_ sender: Any) {
        print("cancel appt button pressed")
        self.completedBool = false
        self.cancelledBool = true
        self.activeBool = true
        performUIUpdatesOnMain {
            self.apptStatusLabel.text = "Cancelled"
            self.apptStatusLabel.textColor = UIColor.red
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid

        let isCancelled = true
        let isActive = false
        let isComplete = false
        let uid = self.apptObjectShared.firebaseClientID!
        let date = self.apptObjectShared.date!
        let treatment = self.apptObjectShared.treatment1!
        let notes = self.apptObjectShared.notes ?? ""
        let clientKey = self.apptObjectShared.firebaseClientID    //ref.child(uid!).key
        let clientApptKey = self.apptObjectShared.firebaseApptID!
        //let clientApptKey = ref.child(date).key
        let fullName =  self.apptObjectShared.firstName! + " " +  self.apptObjectShared.lastName!
        let adminKey = ref.child("\(fullName)").childByAutoId().key

        let post = ["firebaseApptID": clientApptKey,"firebaseClientID": uid, "isCancelled": isCancelled, "isActive": isActive, "isComplete": isComplete, "date": "\(date)", "firstName": "\(self.apptObjectShared.firstName!)",
            "lastName": "\(self.apptObjectShared.lastName!)",
            "phoneNumber": "\(self.apptObjectShared.phoneNumber!)",
            "email": "\(self.apptObjectShared.email!)", "treatment1": "\(treatment)", "notes": "\(notes)"] as [String : Any]
        //let clientChildUpdates = ["/client/clients/\(clientKey)/appointments/\(clientApptKey)": post]
        let adminChildUpdates = ["/admin/appts/allAppts/\(clientApptKey)": post]
       // ref.updateChildValues(clientChildUpdates)
        ref.updateChildValues(adminChildUpdates)

        AlertView.apptCancelAlert(view: self, alertTitle: "Appointment has been canceled!", alertMessage: "")
        apptObjectShared.isCancelled = true
    }
    
    

    @IBAction func completeAppt(_ sender: Any) {
        //AlertView.alertPopUpTwo(view: self, title: "Appointment has been created!", alertMessage: "A member of the StudioMed staff will be in contact shortly to confirm.", buttonTitle: "OK")
        self.apptObjectShared.isComplete = true
        self.apptObjectShared.isCancelled = false
        self.apptObjectShared.isActive = false
        performUIUpdatesOnMain {
            self.apptStatusLabel.text = "Complete"
            self.apptStatusLabel.textColor = UIColor.black
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let isCancelled = false
        let isActive = false
        let isComplete = true
        let uid = self.apptObjectShared.firebaseClientID!
        let date = self.apptObjectShared.date!
        let treatment = self.apptObjectShared.treatment1!
        let notes = self.apptObjectShared.notes ?? ""
        let clientKey = self.apptObjectShared.firebaseClientID    //ref.child(uid!).key
        let clientApptKey = self.apptObjectShared.firebaseApptID!
        let fullName =  self.apptObjectShared.firstName! + " " +  self.apptObjectShared.lastName!
        let adminKey = ref.child("\(fullName)").childByAutoId().key
        
        let post = ["firebaseApptID": clientApptKey,"firebaseClientID": uid, "isCancelled": isCancelled, "isActive": isActive, "isComplete": isComplete, "date": "\(date)", "firstName": "\(self.apptObjectShared.firstName!)",
            "lastName": "\(self.apptObjectShared.lastName!)",
            "phoneNumber": "\(self.apptObjectShared.phoneNumber!)",
            "email": "\(self.apptObjectShared.email!)", "treatment1": "\(treatment)", "notes": "\(notes)"] as [String : Any]
        let clientChildUpdates = ["/client/clients/\(clientKey)/appointments/\(clientApptKey)": post]
        let adminChildUpdates = ["/admin/appts/allAppts/\(clientApptKey)": post]
        ref.updateChildValues(clientChildUpdates)
        ref.updateChildValues(adminChildUpdates)

        AlertView.apptCreateAlert(view: self, alertTitle: "Appointment complete!", alertMessage: "")
        apptObjectShared.isCancelled = false
        apptObjectShared.isComplete = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppointmentData.init()
        print("appt is can = \(self.apptObjectShared.isCancelled)")
        
//        print("colored index is \(coloredCellIndex)")
//        print("user name is \(userObjectShared.email!)")
        navigationController?.navigationBar.isHidden = false
//        self.userFullNameLabel.text = userObjectShared.firstName! + " " + userObjectShared.lastName!
//        self.userPhoneLabel.text = userObjectShared.phoneNumber!
//        self.userEmailLabel.text = userObjectShared.email!
        
        if self.apptObjectShared.isCancelled! == true && self.apptObjectShared.isComplete! == false {
            apptStatusLabel.text = "Cancelled"
            apptStatusLabel.textColor = UIColor.red
        } else if self.apptObjectShared.isCancelled! == false && self.apptObjectShared.isComplete! == true {
            apptStatusLabel.text = "Complete"
            apptStatusLabel.textColor = UIColor.black
        } else if self.apptObjectShared.isCancelled! == false && self.apptObjectShared.isComplete! == false {
            apptStatusLabel.text = "Active"
            apptStatusLabel.textColor = UIColor.green
        }
        userFullNameLabel.text = self.apptObjectShared.firstName! + " " + self.apptObjectShared.lastName!
        userPhoneLabel.text = self.apptObjectShared.phoneNumber!
        userEmailLabel.text = self.apptObjectShared.email!
        apptDateTime.text = self.apptObjectShared.date!
        treatmentLabel.text = self.apptObjectShared.treatment1!
        
        print("firebaseApptID is: \(self.apptObjectShared.firebaseApptID!) ")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
