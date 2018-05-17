//
//  CreateAccountVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateApptVC: UIViewController, UITextViewDelegate{
    
    var ref: DatabaseReference!
    
    var userArray: [UserData] = UserArray.sharedInstance.listOfUsers
    var userObject = UserData()
    
    var apptArray: [AppointmentData] = ApptArray.sharedInstance.listOfAppts
    var apptObject = AppointmentData()
    
    @IBAction func logOutButton(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                present(loginVC, animated: true, completion: nil)
                print("logged out success")
                
            } catch let error as NSError {
                AlertView.alertPopUp(view: self, alertMessage: (error.localizedDescription))
                print(error.localizedDescription)
            }
        }
        
    }
    
    func createDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        let usDateFormat = DateFormatter.dateFormat(fromTemplate: "MMddyyyy, hh mm a", options: 0, locale: NSLocale(localeIdentifier: "en-US") as Locale)
        formatter.dateFormat = usDateFormat
        let usSwiftDayString = formatter.string(from: date)
        print("\(usSwiftDayString)")
        return usSwiftDayString
    }
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var dateTimeButton: UIButton!
    @IBOutlet weak var treatmentOneButton: UIButton!
    @IBOutlet weak var treatmentTwoButton: UIButton!
    @IBOutlet weak var treatmentThreeButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    
     @IBAction func selectDateTime(_ sender: Any) {
    }
    
    @IBAction func selectTreatmentOne(_ sender: Any) {
    }
    
    @IBAction func selectTreatmentTwo(_ sender: Any) {
    }
    
    @IBAction func selectTreatmentThree(_ sender: Any) {
    }
    
    @IBAction func selectLocation(_ sender: Any) {
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        //apptObject.isCancelled = false
        apptObject.date = dateTimeButton.titleLabel?.text!
        apptObject.time = dateTimeButton.titleLabel?.text!
        apptObject.firstName = userObject.firstName
        apptObject.lastName = userObject.lastName
        apptObject.phoneNumber = userObject.phoneNumber
        apptObject.email = userObject.email
        apptObject.treatment1 = treatmentOneButton.titleLabel?.text!
        apptObject.treatment2 = treatmentTwoButton.titleLabel?.text!
        apptObject.treatment3 = treatmentThreeButton.titleLabel?.text!
        apptObject.notes = notesTextView.text!
        apptObject.location = locationButton.titleLabel?.text!
        apptArray.append(apptObject)
        
        print("user array count is: \(apptArray.count)")
        print("user object name is: \(apptObject.firstName)")
        // createAppt()
        //print("createAppt was called")
        
        
        
//        if firstNameText.text == "" || lastNameText.text == "" || phoneNumberText.text == "" || emailText.text == "" || treatment1Text.text == "" {
//            AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
//        } else {
//            let fullName = "\(firstNameText.text! + " " + lastNameText.text!)"
//            let date = createDate()
//            let clientKey = ref.child("\(fullName)").key
//            let clientApptKey = ref.childByAutoId().key
//            let adminKey = ref.child("\(fullName)").key
//            let post = ["date": "\(date)", "firstName": "\(firstNameText.text!)",
//                "lastName": "\(lastNameText.text!)",
//                "phoneNumber": "\(phoneNumberText.text!)",
//                "email": "\(emailText.text!)", "treatment1": "\(treatment1Text.text!)"]
//            let clientChildUpdates = ["/client/users/\(clientKey)/appointments/\(clientApptKey)": post]
//            let adminChildUpdates = ["/admin/appts/allAppts/\(adminKey)": post]
//            ref.updateChildValues(clientChildUpdates)
//            ref.updateChildValues(adminChildUpdates)
//
//                    let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
//                    //listOfAppointmentsVC.userName = fullName
//                    navigationController?.pushViewController(apptDetailVC, animated: true)
       // }
    let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
    //listOfAppointmentsVC.userName = fullName
    navigationController?.pushViewController(apptDetailVC, animated: true)
    }
    
    
    //    func createAppt() {
    //        let key = ref.child("\(firstNameText.text! + " " + lastNameText.text!)").child("appointments").childByAutoId().key
    //        let post = ["firstName": "\(firstNameText.text!)",
    //            "lastName": "\(lastNameText.text!)",
    //            "phoneNumber": "\(phoneNumberText.text!)",
    //            "email": "\(emailText.text!)"]
    //        let childUpdates = ["/client/users/\(firstNameText.text! + " " + lastNameText.text!)`/appointments/\(key)": post]
    //        ref.updateChildValues(childUpdates)
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem?.image = #imageLiteral(resourceName: "ArrowLeftShape")
        navigationItem.backBarButtonItem?.title = ""
        
//        let date = Date()
//        let formatter = DateFormatter()
//        let usDateFormat = DateFormatter.dateFormat(fromTemplate: "MMddyyyy, hh mm a", options: 0, locale: NSLocale(localeIdentifier: "en-US") as Locale)
//        formatter.dateFormat = usDateFormat
//        let usSwiftDayString = formatter.string(from: date)
//        print("\(usSwiftDayString)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        let conditionRef = ref.child("users")
        //        conditionRef.observe(.value, with: (snap: DataSnapshot) -> Void) in
        //        self.firstNameText.text = snap.value.description
        //self.ref.child("client").child("users").child("userEmail").child("meaty").child("lastName").removeValue()
        //self.ref.child("client").child(user.uid).setValue(["username": username])
        //self.ref.child("client").child("users").child("userEmail").child("meaty").child("firstName")
        // self.ref.child("client").child("users").child("userEmail").child("meaty").child("lastName")
        //        self.ref.child("client").child("users").child("userEmail").child("meaty").setValue(["firstName": "Jenny"])
        //        self.ref.child("client").child("users").child("userEmail").child("meaty").setValue(["lastName": "Bae"])
        //print("stuff here is: \(self.ref.child("client").child("users").child("userEmail").child("meaty"))")
        
        //        let key = ref.child("meaty").childByAutoId().key
        //        let post = ["firstName": "userID",
        //                    "lastName": "username",
        //                    "phoneNumber": "title",
        //                    "email": "body"]
        //        let childUpdates = ["/client/users/userEmail/meaty/appointments/\(key)": post]
        //        ref.updateChildValues(childUpdates)
        //
        //        let key2 = ref.child("appt").childByAutoId().key
        //        let post2 = ["date": "02/01/01",
        //                     "time": "14:00PM",
        //                    "treatment": "stuff",
        //                    "location": "in office"]
        //        let childUpdates2 = ["/client/users/userEmail/meaty/appointments/appt\(key2)": post2]
        //        ref.updateChildValues(childUpdates2)
    }
    
}

