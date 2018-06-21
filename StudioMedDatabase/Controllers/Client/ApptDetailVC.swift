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
    var apptObjectShared = AppointmentData.sharedInstance
    var newApptObjectShared = NewAppointmentData.sharedInstance
    var statusVarString = String()

    @IBAction func viewNotesButton(_ sender: Any) {
        
        let clientViewNotesVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientViewNotesVC") as! ClientViewNotesVC

        navigationController?.pushViewController(clientViewNotesVC, animated: true)
    }
    
    func passDataFromNewApptSharedObject() {
        print("self.apptObjectShared.firebaseApptID is: \(self.apptObjectShared.firebaseApptID)")
        
        self.apptObjectShared.date = self.newApptObjectShared.date
        self.apptObjectShared.email = self.newApptObjectShared.email
       // self.apptObjectShared.firebaseApptID = self.newApptObjectShared.firebaseApptID
        self.apptObjectShared.firebaseClientID = self.newApptObjectShared.firebaseClientID
        self.apptObjectShared.firstName = self.newApptObjectShared.firstName
        self.apptObjectShared.isActive = self.newApptObjectShared.isActive
        self.apptObjectShared.isCancelled = self.newApptObjectShared.isCancelled
        self.apptObjectShared.isComplete = self.newApptObjectShared.isComplete
        self.apptObjectShared.lastName = self.newApptObjectShared.lastName
        self.apptObjectShared.notes = self.newApptObjectShared.notes
        self.apptObjectShared.phoneNumber = self.newApptObjectShared.phoneNumber
        self.apptObjectShared.treatment1 = self.newApptObjectShared.treatment1
        
        print("CALLLEDPASS!!!")
        
        print("self.apptObjectShared.firebaseApptID is: \(self.apptObjectShared.firebaseApptID)")
    }
    
    func zeroOutNewApptSharedObject() {
        self.newApptObjectShared.date = nil
        self.newApptObjectShared.email = nil
        self.newApptObjectShared.firebaseApptID = nil
        self.newApptObjectShared.firebaseClientID = nil
        self.newApptObjectShared.firstName = nil
        self.newApptObjectShared.isActive = nil
        self.newApptObjectShared.isCancelled = nil
        self.newApptObjectShared.isComplete = nil
        self.newApptObjectShared.lastName = nil
        self.newApptObjectShared.notes = nil
        self.newApptObjectShared.phoneNumber = nil
        self.newApptObjectShared.treatment1 = nil
    }
    
    func zeroOutApptSharedObject() {
        self.apptObjectShared.date = nil
        self.apptObjectShared.email = nil
        self.apptObjectShared.firebaseApptID = nil
        self.apptObjectShared.firebaseClientID = nil
        self.apptObjectShared.firstName = nil
        self.apptObjectShared.isActive = nil
        self.apptObjectShared.isCancelled = nil
        self.apptObjectShared.isComplete = nil
        self.apptObjectShared.lastName = nil
        self.apptObjectShared.notes = nil
        self.apptObjectShared.phoneNumber = nil
        self.apptObjectShared.treatment1 = nil
    }
    
    @IBOutlet weak var cancelApptOutlet: UIButton!
    
    @IBAction func cancelApptButton(_ sender: Any) {
        print("cancel appt button pressed")
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        apptObjectShared.isCancelled = true
        apptObjectShared.isActive = false
        apptObjectShared.isComplete = false
//
        let isCancelled = true
        let isActive = false
        let isComplete = false
        let uid = self.userObjectShared.fireBaseUID
        let date = self.apptObjectShared.date!
        let treatment = self.apptObjectShared.treatment1!
        let notes = self.apptObjectShared.notes ?? ""
        let clientKey = ref.child(uid!).key
        let clientApptKey = self.apptObjectShared.firebaseApptID!
        let fullName = self.userObjectShared.firstName! + " " + self.userObjectShared.lastName!
        
        print("clientApptKey id is: \(clientApptKey).")
        
        let refCancel = Database.database().reference().root.child("client").child("clients").child(userID!).child("appointments").child(clientApptKey).updateChildValues(["isCancelled": true])
        let refActive = Database.database().reference().root.child("client").child("clients").child(userID!).child("appointments").child(clientApptKey).updateChildValues(["isActive": false])
        let refComplete = Database.database().reference().root.child("client").child("clients").child(userID!).child("appointments").child(clientApptKey).updateChildValues(["isComplete": false])
        print(apptObjectShared.isCancelled)
        
        performUIUpdatesOnMain {
            var date = self.apptDateAndTimeLabel.text
            var treatment = self.treatmentLabel.text
            
            print("date is: \(date).")
            print("treatment is: \(treatment).")
            
            let cancelledAttributes: [NSAttributedStringKey: Any] =
                [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 20)!,
                 NSAttributedStringKey.strikethroughStyle: 1]
            self.apptDateAndTimeLabel.attributedText = NSAttributedString(string: date!, attributes: cancelledAttributes)
            self.apptDateAndTimeLabel.textColor = UIColor(rgb: 0xFF6666)
            self.treatmentLabel.attributedText = NSAttributedString(string: treatment!, attributes: cancelledAttributes)
            self.treatmentLabel.textColor = UIColor(rgb: 0xFF6666)
        }

        AlertView.apptCancelAlert(view: self, alertTitle: "Appointment has been canceled!", alertMessage: "")
    }
    
    func setTextAttributes() {
        var date = self.apptDateAndTimeLabel.text
        var treatment = self.treatmentLabel.text
        
        date = apptObjectShared.date!
        treatment = apptObjectShared.treatment1!
        
        let activeAttributes: [NSAttributedStringKey: Any] =
            [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 20)!,
             NSAttributedStringKey.strikethroughStyle: 0]
        
        let cancelledAttributes: [NSAttributedStringKey: Any] =
            [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 20)!,
             NSAttributedStringKey.strikethroughStyle: 1]
        
        let completeAttributes: [NSAttributedStringKey: Any] =
            [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 20)!,
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
        
        performUIUpdatesOnMain {
            
            self.apptDateAndTimeLabel.text = self.apptObjectShared.date!
            self.treatmentLabel.text = self.apptObjectShared.treatment1!
            
            self.userFullNameLabel.text = self.userObjectShared.firstName! + " " + self.userObjectShared.lastName!
            self.userPhoneLabel.text = self.userObjectShared.phoneNumber!
            self.userEmailLabel.text = self.userObjectShared.email!
 
            self.setTextAttributes()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performUIUpdatesOnMain {
           self.setTextAttributes()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //AppointmentData.dispose()
        performUIUpdatesOnMain {
           // self.zeroOutApptSharedObject()
        }
    }
}
