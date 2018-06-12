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
   // var apptDataLiteShared = AppointmentDataLite.sharedInstance()
    var apptObjectShared = AppointmentData.sharedInstance
    var newApptObjectShared = NewAppointmentData.sharedInstance
    
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
            
//            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstLoginVC")
//            present(loginVC, animated: true, completion: nil)
            let firstLoginNavVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstLoginNavVC")
            //                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            //                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
            present(firstLoginNavVC, animated: true, completion: {
                
                self.tabBarController?.view.removeFromSuperview()
                print("tab bar remove called")
            })
            //self.dismiss(animated: true, completion: nil)
//            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
         
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
        //self.apptObjectShared.date = dateAndTime
        self.newApptObjectShared.date = dateAndTime

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
        
        self.newApptObjectShared.email = userObject.email
        self.newApptObjectShared.firebaseApptID = nil
        self.newApptObjectShared.firebaseClientID = userObjectShared.fireBaseUID
        self.newApptObjectShared.firstName = userObject.firstName
        self.newApptObjectShared.isCancelled = false
        self.newApptObjectShared.isActive = true
        self.newApptObjectShared.isComplete = false
        self.newApptObjectShared.lastName = userObject.lastName
        self.newApptObjectShared.phoneNumber = userObject.phoneNumber

        //apptArray.append(newApptObjectShared)

        print("user array count is: \(apptArray.count)")
        print("user object name is: \(self.newApptObjectShared.firstName)")
        print("user object name is: \(userObject.email)")
        print("user object name is: \(self.newApptObjectShared.email)")

        if newApptObjectShared.date == nil || newApptObjectShared.treatment1 == nil || dateTimeButton.titleLabel?.text == "Select A Date & Time" || treatmentOneButton.titleLabel?.text == "Select A Treatment" {
            AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
        } else {
            let isCancelled = false
            let isActive = true
            let isComplete = false
            let uid = self.userObjectShared.fireBaseUID
            let date = self.newApptObjectShared.date!
            let treatment = self.newApptObjectShared.treatment1!
            let notes = self.valueFromApptNotesVC ?? ""
            let clientKey = ref.child(uid!).key
            let clientApptKey = ref.childByAutoId().key

            let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "RequestApptDetailVC") as! RequestApptDetailVC

            navigationController?.pushViewController(apptDetailVC, animated: true)
        }
        
//
//
//
//        self.apptObjectShared.email = userObject.email
//        self.apptObjectShared.firebaseApptID = nil
//        self.apptObjectShared.firebaseClientID = userObjectShared.fireBaseUID
//        self.apptObjectShared.firstName = userObject.firstName
//        self.apptObjectShared.isCancelled = false
//        self.apptObjectShared.isActive = true
//        self.apptObjectShared.isComplete = false
//        self.apptObjectShared.lastName = userObject.lastName
//        self.apptObjectShared.phoneNumber = userObject.phoneNumber
//
//
//        //newApptObjectShared
//        apptArray.append(apptObjectShared)
//
//        print("user array count is: \(apptArray.count)")
//        print("user object name is: \(self.apptObjectShared.firstName)")
//        print("user object name is: \(userObject.email)")
//        print("user object name is: \(self.apptObjectShared.email)")
//
//        if apptObjectShared.date == nil || apptObjectShared.treatment1 == nil || dateTimeButton.titleLabel?.text == "Select A Date & Time" || treatmentOneButton.titleLabel?.text == "Select A Treatment" {
//            AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
//        } else {
//            let isCancelled = false
//            let isActive = true
//            let isComplete = false
//            let uid = self.userObjectShared.fireBaseUID
//            let date = self.apptObjectShared.date!
//            let treatment = self.apptObjectShared.treatment1!
//            let notes = self.valueFromApptNotesVC ?? ""
//            let clientKey = ref.child(uid!).key
//            let clientApptKey = ref.childByAutoId().key
//
//            let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
//
////            apptDetailVC.apptDateAndTimeLabel.text = apptDataLiteShared.date!
////            apptDetailVC.treatmentLabel.text = apptDataLiteShared.treatment1!
//
//            navigationController?.pushViewController(apptDetailVC, animated: true)
//        }
    }

    func getOneUserData() {
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        print("userID from create new account to create appt is \(userID)")

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
  
    //TODO: FIX IT SO IT WORKS WITH RIGHT PROMPTS
//    func rateAppAlert() {
//        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
//        if currentCount == 12 {
//            print("we launched the app more than 4 times")
//            AlertView.alertPopUp(view: self, alertMessage: "Rate the app!")
//        }
//    }
    
    func resetApptForm() {
        
        if apptObjectShared.date == nil {
        //apptObjectShared.date = "Select A Date & Time"
        self.dateTimeButton.setTitle("Select A Date & Time", for: UIControlState.normal)
        } else {
            apptObjectShared.date = apptObjectShared.date
        }
        
        if apptObjectShared.treatment1 == nil {
            //apptObjectShared.treatment1 = "Select A Treatment"
            self.treatmentOneButton.setTitle("Select A Treatment", for: UIControlState.normal)
        } else {
            apptObjectShared.treatment1 = apptObjectShared.treatment1
        }
        
        if apptObjectShared.notes == nil {
            //apptObjectShared.notes = "Add A Note For The Doctor"
            self.addNotesButton.setTitle("Add A Note For The Doctor", for: UIControlState.normal)
        } else {
            apptObjectShared.notes = apptObjectShared.notes
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem?.image = #imageLiteral(resourceName: "ArrowLeftShape")
        navigationItem.backBarButtonItem?.title = ""

        getOneUserData()
        
//        performUIUpdatesOnMain {
//            self.resetApptForm()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //AppointmentData.dispose()
       // resetApptForm()
//        performUIUpdatesOnMain {
//            self.resetApptForm()
//        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        print("value from TreatmentDetailVC is2: \(newApptObjectShared.treatment1)")
            print("value from GetDateVC is: \(newApptObjectShared.date)")
        
//        performUIUpdatesOnMain {
//            self.resetApptForm()
//        }
       
        getOneUserData()
        
        if let dateToDisplay = newApptObjectShared.date, let timeToDisplay = newApptObjectShared.time {
            print("value from GetDateVC is: \(dateToDisplay) \(timeToDisplay)")
            let dateAndTime = "\(dateToDisplay) \(timeToDisplay)"
            self.dateTimeButton.setTitle("\(dateAndTime)", for: UIControlState.normal)
//            if dateToDisplay == nil {
//                self.dateTimeButton.setTitle("Select A Date & Time", for: UIControlState.normal)
//            }
        }
        
        if let notesValueToDisplay = newApptObjectShared.notes {
            print("value from ApptNotesVC is: \(notesValueToDisplay)")
            self.addNotesButton.setTitle("\(notesValueToDisplay)", for: UIControlState.normal)
        }
        
        if let treatmentValue = newApptObjectShared.treatment1 {
            print("value from TreatmentDetailVC is: \(treatmentValue)")
            self.treatmentOneButton.setTitle("\(treatmentValue)", for: UIControlState.normal)
        }
   }
}

