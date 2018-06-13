//
//  RequestApptDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 6/11/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.


import Foundation
import UIKit
import Firebase

class RequestApptDetailVC: UIViewController {
    var coloredCellIndex = Int()
    var userObjectShared = UserData.sharedInstance()
    var apptObjectShared = AppointmentData.sharedInstance
    var newApptObjectShared = NewAppointmentData.sharedInstance
    var statusVarString = String()
    
    @IBOutlet weak var requestApptOutlet: UIButton!
    @IBAction func viewNotesButton(_ sender: Any) {
        
        let clientViewNotesVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientViewNotesVC") as! ClientViewNotesVC
        //clientViewNotesVC.notesTextView.text = apptObjectShared.notes ?? "No Notes Written."
        navigationController?.pushViewController(clientViewNotesVC, animated: true)
    }
    
    func passDataFromNewApptSharedObject() {
//        print("self.apptObjectShared.firebaseApptID is: \(self.apptObjectShared.firebaseApptID)")
//        print("self.apptObjectShared.firebaseClientID is: \(self.apptObjectShared.firebaseClientID)")
        
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
//
//        print("self.apptObjectShared.firebaseApptID is: \(self.apptObjectShared.firebaseApptID)")
//        print("self.apptObjectShared.firebaseClientID is: \(self.apptObjectShared.firebaseClientID)")
    }
    
    func zeroOutNewApptSharedObject() {
        self.newApptObjectShared.date = "Select A Date & Time"
         self.newApptObjectShared.time = ""
        self.newApptObjectShared.email = nil
        self.newApptObjectShared.firebaseApptID = nil
        self.newApptObjectShared.firebaseClientID = nil
        self.newApptObjectShared.firstName = nil
        self.newApptObjectShared.isActive = nil
        self.newApptObjectShared.isCancelled = nil
        self.newApptObjectShared.isComplete = nil
        self.newApptObjectShared.lastName = nil
        self.newApptObjectShared.notes = "Add A Note For The Doctor"
        self.newApptObjectShared.phoneNumber = nil
        self.newApptObjectShared.treatment1 = "Select A Treatment"
    }
    
    @IBAction func confirmAppt(_ sender: Any) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let isActive = true
        let isCancelled = false
        let isComplete = false
        let uid = self.userObjectShared.fireBaseUID
        let userID = Auth.auth().currentUser?.uid
        let date = self.apptObjectShared.date!
        let treatment = self.apptObjectShared.treatment1!
        let notes = self.apptObjectShared.notes ?? ""
        let clientKey = ref.child(uid!).key
        let clientApptKey = ref.childByAutoId().key
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
        //
        performUIUpdatesOnMain {
            self.zeroOutNewApptSharedObject()
        }
        apptObjectShared.isActive = true
        apptObjectShared.isCancelled = false
        apptObjectShared.isComplete = false
        apptObjectShared.firebaseApptID = clientApptKey
        
        AlertView.apptCreateAlert(view: self, alertTitle: "Appointment request has been created!", alertMessage: "A member of the StudioMed staff will be in contact shortly to confirm.")

    }
    
    func resetApptForm() {
        let createApptVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateApptVC") as! CreateApptVC
        if apptObjectShared.date == nil {
            //apptObjectShared.date = "Select A Date & Time"
            createApptVC.dateTimeButton.setTitle("Select A Date & Time", for: UIControlState.normal)
        } else {
            apptObjectShared.date = apptObjectShared.date
        }
        
        if apptObjectShared.treatment1 == nil {
            //apptObjectShared.treatment1 = "Select A Treatment"
            createApptVC.treatmentOneButton.setTitle("Select A Treatment", for: UIControlState.normal)
        } else {
            apptObjectShared.treatment1 = apptObjectShared.treatment1
        }
        
        if apptObjectShared.notes == nil {
            //apptObjectShared.notes = "Add A Note For The Doctor"
            createApptVC.addNotesButton.setTitle("Add A Note For The Doctor", for: UIControlState.normal)
        } else {
            apptObjectShared.notes = apptObjectShared.notes
        }
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
            self.passDataFromNewApptSharedObject()
            
            self.requestApptOutlet.isHidden = false

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

