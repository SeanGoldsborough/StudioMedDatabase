//
//  ClientAppointmentHistoryVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase



class ClientAppointmentHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    
    
    
    //var arrayOfUsers = [UserData]()
    //var users = UserArray.sharedInstance.listOfUsers
    var userName = String()
    var userNames = [String]()
    var userData = [DataSnapshot]()
    //var postData = ["one", "two", "three"]
    var postData = [UserData]()
    //var users = [User]()
    var appointments = [Appointment]()
    var filteredAppointments = [Appointment]()
    //var filteredUsers = [User]()
    var selectedIndexes = [Int]()
    var apptObjectShared = AppointmentData.sharedInstance
    
    var myBool = false
    var coloredCellIndex = 1000
    
    @IBAction func logOutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("google signout okay")
            
            apptObjectShared.date = "Select A Date & Time"
            apptObjectShared.treatment1 = "Select A Treatment"
            apptObjectShared.notes = "Add A Note For The Doctor"
            
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstLoginVC")
            present(loginVC, animated: true, completion: nil)
            print("logged out success \(firebaseAuth.currentUser)")
            
        } catch let error as NSError {
            AlertView.alertPopUp(view: self, alertMessage: (error.localizedDescription))
            print(error.localizedDescription)
            print ("Error signing out: %@", error)
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("user name is: \(userName)")
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        //navigationController?.navigationBar.isHidden = true
        
        //print(users.count)
        
        if appointments.count < 1 {
            getData()
        }
        
        //navigationController?.navigationItem.title = "Hi, \(userName)"
        
        //        var user = User(firstNameText: "test", lastNameText: "test")
        //        print("user object fn is: \(user.firstName)")
        //        print("user object ln is: \(user.lastName)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getData()
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    
    func getData() {
        let userID = Auth.auth().currentUser?.uid
        
        databaseHandle = ref.child("client").child("clients").child(userID!).child("appointments").queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) in

            if let apptDict = snapshot.value as? [String : AnyObject] {
                print("apptDict is \(apptDict)")
                
                let apptFirebaseApptID = apptDict["firebaseApptID"] as! String
                let apptFirebaseClientID = apptDict["firebaseClientID"] as! String
                let apptIsCancelledBool = apptDict["isCancelled"] as! Bool
                let apptIsActiveBool = apptDict["isActive"] as! Bool
                let apptIsCompleteBool = apptDict["isComplete"] as! Bool
                let firstNameText = apptDict["firstName"] as! String
                let lastNameText = apptDict["lastName"] as! String
                let phoneNumberText = apptDict["phoneNumber"] as! String
                let emailText = apptDict["email"] as! String
                let dateText = apptDict["date"] as! String
                let treatmentText = apptDict["treatment1"] as! String
                let notesText = apptDict["notes"] as! String
                
                let appointment = Appointment(firebaseApptIDString: apptFirebaseApptID, firebaseClientIDString: apptFirebaseClientID, isCancelledBool: apptIsCancelledBool, isActiveBool: apptIsActiveBool, isCompleteBool: apptIsCompleteBool, firstNameText: firstNameText, lastNameText: lastNameText, phoneNumberText: phoneNumberText, emailText: emailText, dateText: dateText, treatment1Text: treatmentText, notesText: notesText)

                print("apptDict is \(apptDict)")
                self.appointments.append(appointment)
                print("apptDict array is \(self.appointments)")
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }
            //self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        self.appointments.sort(by: {$0.date > $1.date})
        let appointment: Appointment

        appointment = appointments[indexPath.row]

        cell.textLabel?.text = appointment.firstName + " " + appointment.lastName
        cell.detailTextLabel?.text = appointment.date + "    " + appointment.treatment1
  
        if appointment.isCancelled == true {
            
            performUIUpdatesOnMain {
           
                let topAttributes: [NSAttributedStringKey: Any] =
                    [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 24)!,
                     NSAttributedStringKey.strikethroughStyle: 1]
                
                let bottomAttributes: [NSAttributedStringKey: Any] =
                    [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 17)!,
                     NSAttributedStringKey.strikethroughStyle: 1]
                
                let topText = appointment.firstName + " " + appointment.lastName
                let bottomText = appointment.date + "    " + appointment.treatment1
                
                cell.textLabel?.attributedText = NSAttributedString(string: topText, attributes: topAttributes)
                cell.textLabel?.textColor = UIColor.lightGray
                cell.textLabel?.alpha = 0.5
                
                cell.detailTextLabel?.attributedText = NSAttributedString(string: bottomText, attributes: bottomAttributes)
                cell.detailTextLabel?.textColor = UIColor.lightGray
                cell.detailTextLabel?.alpha = 0.5
                
                cell.backgroundColor = UIColor.darkGray
                
            self.tableView.reloadData()
                
            }
            
        } else if appointment.isCancelled == false {
            performUIUpdatesOnMain {
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = UIColor.black  
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appointment: Appointment
        
        appointment = appointments[indexPath.row]
          print("selected appt is can = \(appointment.isCancelled)")
        
//        self.coloredCellIndex = indexPath.row
        let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
        
        //apptObjectShared = appointments[indexPath.row]
        //        print("selected a user \(users[indexPath.row].email)")
        //TODO: REFACTOR INTO A FUNCTION AND CALL IT HERE
                let firebaseApptIDString = appointments[indexPath.row].firebaseApptID
                let firebaseClientIDString = appointments[indexPath.row].firebaseClientID
                let isCancelledBool = appointments[indexPath.row].isCancelled
                let isActiveBool = appointments[indexPath.row].isActive
                let isCompleteBool = appointments[indexPath.row].isComplete
                let firstName = appointments[indexPath.row].firstName
                let lastName = appointments[indexPath.row].lastName
                let phoneNumber = appointments[indexPath.row].phoneNumber
                let email = appointments[indexPath.row].email
                let date = appointments[indexPath.row].date
                let treatment = appointments[indexPath.row].treatment1
                let notes = appointments[indexPath.row].notes
        
            self.apptObjectShared.firebaseApptID = firebaseApptIDString
            self.apptObjectShared.firebaseApptID = firebaseClientIDString
            self.apptObjectShared.isCancelled = isCancelledBool
            self.apptObjectShared.isActive = isActiveBool
            self.apptObjectShared.isComplete = isCompleteBool
            self.apptObjectShared.firstName = firstName
            self.apptObjectShared.lastName = lastName
            self.apptObjectShared.phoneNumber = phoneNumber
            self.apptObjectShared.email = email
            self.apptObjectShared.date = date
            self.apptObjectShared.treatment1 = treatment
            self.apptObjectShared.notes = notes
        
        
        
//                apptDetailVC.clientName = firstName + " " + lastName // should be date and time
//                apptDetailVC.phoneNumber = phoneNumber // should be treatment
//                apptDetailVC.email = email // should be notes
        apptDetailVC.coloredCellIndex = indexPath.row
        navigationController?.pushViewController(apptDetailVC, animated: true)
        
    }
    
    func populateApptSharedObject() {
        
    }
}



