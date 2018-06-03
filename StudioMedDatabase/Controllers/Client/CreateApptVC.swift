//
//  CreateApptVC.swift
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

class CreateApptVC: UIViewController, UITextViewDelegate, GetDataProtocol, DateTimePickerDelegate{
    
    var picker: DateTimePicker?
    
    func setResultOfGetDate(valueSent: String) {
        self.valueFromGetDateVC = valueSent
    }
    
    func setResultOfGetTreatment(valueSent: String) {
        self.valueFromTreatmentDetailVC = valueSent
    }
    
    func setResultOfGetNotes(valueSent: String) {
        self.valueFromApptNotesVC = valueSent
    }

    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var userID = Auth.auth().currentUser?.uid
    
    var userArray: [UserData] = UserArray.sharedInstance.listOfUsers
    var userObject = UserData()
    var userObjectShared = UserData.sharedInstance()
    
    var apptArray: [AppointmentData] = ApptArray.sharedInstance.listOfAppts
    var apptObject = AppointmentData()
    var apptObjectShared = AppointmentData.sharedInstance()
    
    var valueFromGetDateVC:String?
    var valueFromApptNotesVC:String?
    var valueFromTreatmentDetailVC:String?
    
    @IBAction func logOutButton(_ sender: Any) {

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("google signout okay")
            
            apptObjectShared.date = "Select A Date & Time"
            apptObjectShared.time = ""
            apptObjectShared.treatment1 = "Select A Treatment"
            apptObjectShared.notes = "Add A Note For The Doctor"
            
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstLoginVC")
            present(loginVC, animated: true, completion: nil)
            print("logged out success \(firebaseAuth.currentUser)")
            userObjectShared.firstName = ""
            print("logged out success \(userObjectShared)")
            
        } catch let error as NSError {
            AlertView.alertPopUp(view: self, alertMessage: (error.localizedDescription))
            print(error.localizedDescription)
            print ("Error signing out: %@", error)
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
//    @IBOutlet weak var treatmentTwoButton: UIButton!
//    @IBOutlet weak var treatmentThreeButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var addNotesButton: UIButton!
    
    @IBAction func addANote(_ sender: Any) {
        let apptNotesVC = self.storyboard?.instantiateViewController(withIdentifier: "ApptNotesVC") as! ApptNotesVC
        //Set the delegate
        apptNotesVC.delegate = self
        self.navigationController?.pushViewController(apptNotesVC, animated: true)
        
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        let dateAndTime = picker.selectedDateString
        //title = dateAndTime
        self.dateTimeButton.setTitle("\(dateAndTime)", for: UIControlState.normal)
        self.apptObjectShared.date = dateAndTime
        
    }
    
     @IBAction func selectDateTime(_ sender: Any) {
//        let getDateVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
//        //Set the delegate
//        getDateVC.delegate = self
//        self.navigationController?.pushViewController(getDateVC, animated: true)
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "REQUEST THIS DATE"
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.locale = Locale(identifier: "en_GB")
        
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "MM/dd/YYYY hh:mm aa"
        //        picker.isTimePickerOnly = true
        picker.includeMonth = true // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY hh:mm aa"
            //self.title = formatter.string(from: date)
            
        
        }
        picker.delegate = self
        self.picker = picker
    }
    
    @IBAction func selectTreatmentOne(_ sender: Any) {
    }
    
    
    @IBAction func createApptButton(_ sender: Any) {
        //apptObject.isCancelled = false
//        apptObject.date = dateTimeButton.titleLabel?.text!
//        apptObject.time = dateTimeButton.titleLabel?.text!
        self.apptObjectShared.isCancelled = false
        self.apptObjectShared.isActive = true
        self.apptObjectShared.isComplete = false
        self.apptObjectShared.firebaseClientID = userObjectShared.fireBaseUID
        self.apptObjectShared.firstName = userObject.firstName
        self.apptObjectShared.lastName = userObject.lastName
        self.apptObjectShared.phoneNumber = userObject.phoneNumber
        self.apptObjectShared.email = userObject.email
        
//        apptObject.treatment1 = treatmentOneButton.titleLabel?.text!
//        apptObject.notes = notesTextView.text!

//        apptArray.append(apptObject)
        apptArray.append(apptObjectShared)
        
        print("user array count is: \(apptArray.count)")
        print("user object name is: \(self.apptObjectShared.firstName)")
        print("user object name is: \(userObject.email)")
        print("user object name is: \(self.apptObjectShared.email)")
        // createAppt()
        //print("createAppt was called")
        
        
        
        if apptObjectShared.date == nil || apptObjectShared.treatment1 == nil || dateTimeButton.titleLabel?.text == "Select A Date & Time" || treatmentOneButton.titleLabel?.text == "Select A Treatment" {
            AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
        } else {
            let isCancelled = false
            let isActive = true
            let isComplete = false
            let uid = self.userObjectShared.fireBaseUID
            let date = self.apptObjectShared.date!
            let treatment = self.apptObjectShared.treatment1!
            let notes = self.valueFromApptNotesVC ?? ""
            let clientKey = ref.child(uid!).key
            let clientApptKey = ref.childByAutoId().key
            //let clientApptKey = ref.child(date).key
//            let fullName = self.userObjectShared.firstName! + " " + self.userObjectShared.lastName!
//            let adminKey = ref.child("\(fullName)").childByAutoId().key
//            let post = ["isCancelled": isCancelled, "date": "\(date)", "firstName": "\(self.userObjectShared.firstName!)",
//                "lastName": "\(self.userObjectShared.lastName!)",
//                "phoneNumber": "\(self.userObjectShared.phoneNumber!)",
//                "email": "\(self.userObjectShared.email!)", "treatment1": "\(treatment)", "notes": "\(notes)"] as [String : Any]
//            let clientChildUpdates = ["/client/clients/\(clientKey)/appointments/\(clientApptKey)": post]
//           let adminChildUpdates = ["/admin/appts/allAppts/\(adminKey)": post]
//            ref.updateChildValues(clientChildUpdates)
//            ref.updateChildValues(adminChildUpdates)

//                    let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
//                    //listOfAppointmentsVC.userName = fullName
//                    navigationController?.pushViewController(apptDetailVC, animated: true)
       // }
            let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
    //listOfAppointmentsVC.userName = fullName
            navigationController?.pushViewController(apptDetailVC, animated: true)
        }
    }
    
//    func getDataFromFirebase() {
//        databaseHandle = ref.child("client").child("clients").child(userID!).observe(.childAdded, with: { (snapshot) in
//            if let userDict = snapshot.value as? [String : AnyObject] {
//                print("userDict is \(userDict)")
//
//                let firstNameText = userDict["firstName"] as! String
//                let lastNameText = userDict["lastName"] as! String
//                let phoneNumberText = userDict["phoneNumber"] as! String
//                let zipCodeText = userDict["zipCode"] as! String
//                let emailText = userDict["email"] as! String
//
//                self.userObjectShared.fireBaseUID = self.userID!
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
    
    func getOneUserData() {
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        print("userID from create new account to create appt is \(userID)")
        //let userID = "ks5xtiGRZNWfaVvgAtK9zHWekru1"
        ref.child("client").child("clients").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userDict = snapshot.value as? NSDictionary
            let fireBaseUIDText  = userDict!["fireBaseUID"] as! String
            let firstNameText = userDict!["firstName"] as! String
            let lastNameText = userDict!["lastName"] as! String
            let phoneNumberText = userDict!["phoneNumber"] as! String
            let zipCodeText = userDict!["zipCode"] as! String
            let emailText = userDict!["email"] as! String
            let allowNotificationsBool = userDict!["allowNotifications"] as! Bool
            let allowEmailNewsletterBool = userDict!["allowEmailNewsletter"] as! Bool
            //let user = User(username: username)
            print("userDict1 is \(userDict)")
            
            performUIUpdatesOnMain {
                self.userObjectShared.fireBaseUID = self.userID!
                self.userObjectShared.firstName = firstNameText
                self.userObjectShared.lastName = lastNameText
                self.userObjectShared.phoneNumber = phoneNumberText
                self.userObjectShared.zipCode = zipCodeText
                self.userObjectShared.email = Auth.auth().currentUser?.email!
                //self.emailSwith
                self.greetingLabel.text = "Welcome, \(self.userObjectShared.firstName!)!"
                
                print("userDict is \(self.userObjectShared.fireBaseUID)")
                print("userDict is \(self.userObjectShared.firstName)")
                print("userDict is \(self.userObjectShared.lastName)")
                print("userDict is \(self.userObjectShared.phoneNumber)")
                print("userDict is \(self.userObjectShared.zipCode)")
                print("userDict is \(self.userObjectShared.email)")
                
            }
            // ...
        }) { (error) in
            AlertView.alertPopUp(view: self, alertMessage: "Unable to load data. \(error.localizedDescription)")
            print(error.localizedDescription)
        }
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
    
    func getUserData() {
        
        let userID : String = (Auth.auth().currentUser?.uid)!
        print("Current user ID is" + userID)
        
        self.ref.child("clients").child(userID).observeSingleEvent(of: .value, with: {(snapshot) in
             print("Current snapshot value is...")
            print(snapshot.value)
            
//            let userEmail = (snapshot.value as! NSDictionary)["email"] as! String
//            print(userEmail)
            
            
        })
        
        //databaseHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            // ...
//            }
//
//        if Auth.auth().currentUser != nil {
//            // User is signed in.
//            // ...
//        } else {
//            // No user is signed in.
//            // ...
//        }
//
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let firstName = user.displayName
            let phone = user.phoneNumber
            
            self.userObjectShared.firstName = firstName!
            
            //let photoURL = user.photoURL
            // ...
            print("userID is: \(uid)")
            print("email is: \(email)")
            print("name is: \(firstName)")
            print("phone is: \(phone)")
            self.greetingLabel.text = "Welcome, \(self.userObjectShared.firstName!)!"
       }
        
        
//        databaseHandle = ref.child("client").child("clients").child("\(self.userID!)").observe(.childAdded, with: { (snapshot) in
//
//            print("userID is: \(self.userID)")
//            print("snapshot is: \(snapshot)")
//            print("snapshot is: \(snapshot)")
//            if let userDict = snapshot.value as? [String : AnyObject] {
//
//                let firstNameText = userDict["firstName"] as! String
//                let lastNameText = userDict["lastName"] as! String
//                let phoneNumberText = userDict["phoneNumber"] as! String
//                let zipCodeText = userDict["zipCode"] as! String
//                let emailText = userDict["email"] as! String
//                let passwordText = userDict["password"] as! String
//
//
//                self.userObjectShared.fireBaseUID = self.userID
//                self.userObjectShared.firstName = firstNameText
//                self.userObjectShared.lastName = lastNameText
//                self.userObjectShared.phoneNumber = phoneNumberText
//                self.userObjectShared.zipCode = zipCodeText
//                self.userObjectShared.email = emailText
//                self.userObjectShared.password = passwordText
//
//
//                let user = User(firstNameText: firstNameText, lastNameText: lastNameText, phoneNumberText: phoneNumberText, emailText: emailText, zipCodeText: zipCodeText)
//                print("userDict is \(userDict)")
//
//                print("userFirstNameText is: \(firstNameText)")
//                self.userObjectShared.firstName = firstNameText
//                self.greetingLabel.text = "Welcome, \(self.userObjectShared.firstName)!"
//            }
//            //self.tableView.reloadData()
//        })
    }
    
    //TODO: FIX IT SO IT WORKS WITH RIGHT PROMPTS
//    func rateAppAlert() {
//        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
//        if currentCount == 12 {
//            print("we launched the app more than 4 times")
//            AlertView.alertPopUp(view: self, alertMessage: "Rate the app!")
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem?.image = #imageLiteral(resourceName: "ArrowLeftShape")
        navigationItem.backBarButtonItem?.title = ""
        
        
        //getUserData()
        //rateAppAlert()
        getOneUserData()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("value from TreatmentDetailVC is2: \(apptObjectShared.treatment1)")
            print("value from GetDateVC is: \(apptObjectShared.date)")
//            self.dateTimeButton.setTitle("\(valueFromGetDateVC)", for: UIControlState.normal)
//
//            print("value from TreatmentDetailVC is: \(valueFromTreatmentDetailVC)")
//            self.treatmentOneButton.setTitle("\(apptObjectShared.treatment1)", for: UIControlState.normal)
//
//            print("value from ApptNotesVC is: \(valueFromApptNotesVC)")
//            self.addNotesButton.setTitle("\(valueFromApptNotesVC)", for: UIControlState.normal)
        
        
        
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
        
//        if let valueToDisplay = valueFromGetDateVC {
//            print("value from GetDateVC is: \(valueToDisplay)")
//            self.dateTimeButton.setTitle("\(valueToDisplay)", for: UIControlState.normal)
//        } else if let valueToDisplay = valueFromTreatmentDetailVC {
//            print("value from TreatmentDetailVC is: \(valueToDisplay)")
//            self.treatmentOneButton.setTitle("\(valueToDisplay)", for: UIControlState.normal)
//        } else if let valueToDisplay = valueFromApptNotesVC {
//            print("value from ApptNotesVC is: \(valueToDisplay)")
//            self.addNotesButton.setTitle("\(valueToDisplay)", for: UIControlState.normal)
//        }
        
//        if let dateToDisplay = apptObjectShared.date, let timeToDisplay = apptObjectShared.time {
//            print("value from GetDateVC is: \(dateToDisplay) \(timeToDisplay)")
//            self.dateTimeButton.setTitle("\(dateToDisplay) \(timeToDisplay)", for: UIControlState.normal)
//        }
        
        if let dateToDisplay = apptObjectShared.date, let timeToDisplay = apptObjectShared.time {
            print("value from GetDateVC is: \(dateToDisplay) \(timeToDisplay)")
            let dateAndTime = "\(dateToDisplay) \(timeToDisplay)"
            self.dateTimeButton.setTitle("\(dateAndTime)", for: UIControlState.normal)
        }
        
        if let notesValueToDisplay = apptObjectShared.notes {
            print("value from ApptNotesVC is: \(notesValueToDisplay)")
            self.addNotesButton.setTitle("\(notesValueToDisplay)", for: UIControlState.normal)
        }
        
        if let treatmentValue = apptObjectShared.treatment1 {
            print("value from TreatmentDetailVC is: \(treatmentValue)")
            self.treatmentOneButton.setTitle("\(treatmentValue)", for: UIControlState.normal)
        }
   }
    
    
}

