//
//  ClientAppointmentHistoryVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.

import UIKit
import Firebase


class ClientAppointmentHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    let searchController = UISearchController(searchResultsController: nil)
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
    var apptObjectShared = AppointmentData.sharedInstance()
    
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
    
    // MARK: - Private instance methods - RW Tutorial - https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredAppointments = appointments.filter({( appointment : Appointment) -> Bool in
            //return candy.name.lowercased().contains(searchText.lowercased())
            //return user.firstName.lowercased().contains(searchText.lowercased())
            return appointment.date.lowercased().contains(searchText.lowercased())
        })
        
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("user name is: \(userName)")
        tableView.dataSource = self
        tableView.delegate = self
        
        // Setup the Search Controller
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.barStyle = .default
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Past Appointments"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
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
        tableView.reloadData()
        //        let query = ref.queryOrderedByKey() /*or a more sophisticated query of your choice*/
        //
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
    }
    
    func getData() {
        let userID = Auth.auth().currentUser?.uid
        databaseHandle = ref.child("client").child("clients").child(userID!).child("appointments").observe(.childAdded, with: { (snapshot) in
            if let apptDict = snapshot.value as? [String : AnyObject] {
                print("apptDict is \(apptDict)")
                
                let apptIsCancelledBool = apptDict["isCancelled"] as! Bool
                let firstNameText = apptDict["firstName"] as! String
                let lastNameText = apptDict["lastName"] as! String
                let phoneNumberText = apptDict["phoneNumber"] as! String
                //let zipCodeText = userDict["zipCode"] as! String
                let emailText = apptDict["email"] as! String
                let dateText = apptDict["date"] as! String
                let treatmentText = apptDict["treatment1"] as! String
                let notesText = apptDict["notes"] as! String
                
                let appointment = Appointment(isCancelledBool: apptIsCancelledBool, firstNameText: firstNameText, lastNameText: lastNameText, phoneNumberText: phoneNumberText, emailText: emailText, dateText: dateText, treatment1Text: treatmentText, notesText: notesText)

//                let user = User(firstNameText: firstNameText, lastNameText: lastNameText, phoneNumberText: dateText, emailText: emailText, zipCodeText: treatmentText)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredAppointments.count
        }
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        let appointment: Appointment
        if isFiltering() {
            appointment = filteredAppointments[indexPath.row]
        } else {
            appointment = appointments[indexPath.row]
        }
        
        cell.textLabel?.text = appointment.firstName + " " + appointment.lastName
        cell.detailTextLabel?.text = appointment.date + "    " + appointment.treatment1
        
        print("appt is can = \(appointment.isCancelled)")
        
        
        
        if appointment.isCancelled == true {
            
            let topAttributes: [NSAttributedStringKey: Any] =
                [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 24)!,
                 NSAttributedStringKey.strikethroughStyle: 1]
            
            let bottomAttributes: [NSAttributedStringKey: Any] =
                [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 14)!,
                 NSAttributedStringKey.strikethroughStyle: 1]
            
            let topText = appointment.firstName + " " + appointment.lastName
            let bottomText = appointment.date + "    " + appointment.treatment1
            
            cell.textLabel?.attributedText = NSAttributedString(string: topText, attributes: topAttributes)
            cell.textLabel?.textColor = UIColor.red
            cell.textLabel?.alpha = 0.5
            
            cell.detailTextLabel?.attributedText = NSAttributedString(string: bottomText, attributes: bottomAttributes)
            cell.detailTextLabel?.textColor = UIColor.red
            cell.detailTextLabel?.alpha = 0.5
            
            cell.backgroundColor = UIColor.darkGray
            
        } else {
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.black
            
        }
        
        
        
//        let firstName = users[indexPath.row].firstName
//        let lastName = users[indexPath.row].lastName
//        let phoneNumber = users[indexPath.row].phoneNumber
//        let email = users[indexPath.row].email
//        var zip = users[indexPath.row].zipCode
//
//        cell.textLabel?.text = firstName + " " + lastName
//        cell.detailTextLabel?.text = phoneNumber + "    " + email
        
//        if myBool == false {
//            cell.textLabel?.textColor = UIColor.red
//        } else {
//            cell.textLabel?.textColor = UIColor.black
//        }
//        var zipBool = "0"
//        print("selected indexes: \(self.selectedIndexes)")
//        print("zip is \(phoneNumber)")
//                if phoneNumber == zipBool {
//                    cell.textLabel?.textColor = UIColor.white
//                    cell.backgroundColor = UIColor.red
//                } else {
//                    cell.textLabel?.textColor = UIColor.black
//                    cell.backgroundColor = UIColor.white
//                }
//        
//        if [indexPath.row] == selectedIndexes {
//            cell.textLabel?.textColor = UIColor.white
//            cell.backgroundColor = UIColor.blue
//        } else {
//            cell.textLabel?.textColor = UIColor.black
//            cell.backgroundColor = UIColor.white
//        }
        
//        if (indexPath.row == coloredCellIndex) {
//            cell.backgroundColor = UIColor.red
//        } else {
//            cell.backgroundColor = UIColor.white
//        }
        
        
        //
        //       let dataSource = FirebaseTableViewDataSource(query: self.ref, modelClass:nil, prototypeReuseIdentifier: "Cell", view: tableView)
        //
        //        dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
        //            let snap = obj as! FDataSnapshot
        //
        //            // Populate cell as you see fit, like as below
        //            cell.textLabel?.text = snap.key as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.coloredCellIndex = indexPath.row
        let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
        //        print("selected a user \(users[indexPath.row].email)")
                let firstName = appointments[indexPath.row].firstName
                let lastName = appointments[indexPath.row].lastName
                let phoneNumber = appointments[indexPath.row].phoneNumber
                let email = appointments[indexPath.row].email
        
//                apptDetailVC.clientName = firstName + " " + lastName // should be date and time
//                apptDetailVC.phoneNumber = phoneNumber // should be treatment
//                apptDetailVC.email = email // should be notes
        apptDetailVC.coloredCellIndex = indexPath.row
        navigationController?.pushViewController(apptDetailVC, animated: true)
        
    }
}

extension ClientAppointmentHistoryVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

