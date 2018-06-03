//
//  PreviousApptsVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class PreviousApptsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    //var arrayOfUsers = [UserData]()
    //var users = UserArray.sharedInstance.listOfUsers
    var userName = String()
    var userNames = [String]()
    var userData = [DataSnapshot]()
    //var postData = ["one", "two", "three"]
    var postData = [UserData]()
    var users = [User]()
    var appointments = [Appointment]()
    var dummyData  = ["10/10/10 - 01:00 PM - Infusion", "10/10/10 - 01:00 PM - Infusion", "10/10/10 - 01:00 PM - Infusion"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("user name is: \(userName)")
        tableView.dataSource = self
        tableView.delegate = self
        //print(users.count)
        
        if appointments.count < 1 {
            getData()
        }
        
        //        var user = User(firstNameText: "test", lastNameText: "test")
        //        print("user object fn is: \(user.firstName)")
        //        print("user object ln is: \(user.lastName)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if users == nil {
            getData()
        }
        
        
        //let query = ref.queryOrderedByKey() /*or a more sophisticated query of your choice*/
        
        
    }
    
//    func getData() {
//        databaseHandle = ref.child("client").child("users").observe(.childAdded, with: { (snapshot) in
//            if let userDict = snapshot.value as? [String : AnyObject] {
//
//                let firstNameText = userDict["firstName"] as! String
//                let lastNameText = userDict["lastName"] as! String
//                let phoneNumberText = userDict["phoneNumber"] as! String
//                let emailText = userDict["email"] as! String
//                let zipCodeText = userDict["zipCode"] as! String
//
//
//                let user = User(firstNameText: firstNameText, lastNameText: lastNameText, phoneNumberText: phoneNumberText, emailText: emailText, zipCodeText: zipCodeText)
//                print("userDict is \(userDict)")
//                self.users.append(user)
//                print("users array is \(self.users)")
//                performUIUpdatesOnMain {
//                    self.tableView.reloadData()
//                }
//            }
//            self.tableView.reloadData()
//        })
//    }
    
    func getData() {
        let userID = Auth.auth().currentUser?.uid
        databaseHandle = ref.child("client").child("clients").child(userID!).child("appointments").observe(.childAdded, with: { (snapshot) in
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
            self.tableView.reloadData()
        })
    }
    func isFiltering() -> Bool {
        //return searchController.isActive && !searchBarIsEmpty()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
//        let firstName = users[indexPath.row].firstName
//        let lastName = users[indexPath.row].lastName
//        let phoneNumber = users[indexPath.row].phoneNumber
//        let email = users[indexPath.row].email
        cell.textLabel?.text = appointments[indexPath.row].date
        cell.detailTextLabel?.text = appointments[indexPath.row].treatment1
        
        let appointment: Appointment
        if isFiltering() {
            appointment = appointments[indexPath.row]
        } else {
            appointment = appointments[indexPath.row]
        }
        
        if appointment.isCancelled == true {
            
            let topAttributes: [NSAttributedStringKey: Any] =
                [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 24)!,
                 NSAttributedStringKey.strikethroughStyle: 1]
            
            let bottomAttributes: [NSAttributedStringKey: Any] =
                [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 17)!,
                 NSAttributedStringKey.strikethroughStyle: 1]
        
            let topText = appointment.date
            let bottomText = appointment.treatment1
            
            cell.textLabel?.attributedText = NSAttributedString(string: topText, attributes: topAttributes)
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.alpha = 0.5
            
            cell.detailTextLabel?.attributedText = NSAttributedString(string: bottomText, attributes: bottomAttributes)
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.detailTextLabel?.alpha = 0.5
            
            cell.backgroundColor = UIColor.darkGray
            
        } else {
            cell.textLabel?.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let adminApptDetailVC = storyboard?.instantiateViewController(withIdentifier: "AdminApptDetailVC") as! AdminApptDetailVC
//        print("selected a user \(users[indexPath.row].email)")
//        let firstName = users[indexPath.row].firstName
//        let lastName = users[indexPath.row].lastName
//        let phoneNumber = users[indexPath.row].phoneNumber
//        let email = users[indexPath.row].email
//
//        userDetailVC.clientName = firstName + " " + lastName
//        userDetailVC.phoneNumber = phoneNumber
//        userDetailVC.email = email
        
        navigationController?.pushViewController(adminApptDetailVC, animated: true)
        
    }
}
