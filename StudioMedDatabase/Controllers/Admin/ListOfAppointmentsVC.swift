//
//  ListOfAppointments.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.

import UIKit
import Firebase


class ListOfAppointmentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    //var sortedAppointments = [Appointment]()
    var filteredAppointments = [Appointment]()
    var userObject = UserData.sharedInstance()
    var apptObjectShared = AppointmentData.sharedInstance()
    var listOfAppointmentsVCBool = false
    
    let searchController = UISearchController(searchResultsController: nil)

    @IBAction func logoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print ("google signout okay")
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstLoginVC")
            present(loginVC, animated: true, completion: nil)
            print("logged out success \(firebaseAuth.currentUser)")
            
        } catch let error as NSError {
            AlertView.alertPopUp(view: self, alertMessage: (error.localizedDescription))
            print(error.localizedDescription)
            print ("Error signing out: %@", error)
        }    }
    
    @IBOutlet weak var tableView: UITableView!
   
    
    
//    var testArray = [String]()
//    var convertedArray: [Date] = []
//
//    var dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "dd MM, yyyy"// yyyy-MM-dd"
//
//    for date in testArray {
//    let date = dateFormatter.date(from: dat)
//    if let date = date {
//    convertedArray.append(date)
//    }
//    }
    
//    var ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
//
//    print(ready)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("user name is: \(userName)")
        tableView.dataSource = self
        tableView.delegate = self
        
        
        if appointments.count < 1 {
            getData()
        }
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Appointments By Date"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor(rgb: 0xFF6666)
        
        
        //navigationController?.navigationBar.topItem?.title = "Hi, \(userObject.firstName!)"
        //navigationItem.title = "Hi, \(userName)"
        
        //        var user = User(firstNameText: "test", lastNameText: "test")
        //        print("user object fn is: \(user.firstName)")
        //        print("user object ln is: \(user.lastName)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
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
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredAppointments = appointments.filter({( appointment : Appointment) -> Bool in
            return appointment.date.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func getData() {
        databaseHandle = ref.child("admin").child("appts").child("allAppts").observe(.childAdded, with: { (snapshot) in
            if let apptDict = snapshot.value as? [String : AnyObject] {
                print("apptDict1 on list of appt in admin is \(apptDict)")
                
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
                
                print("apptDict2 is \(apptDict)")
                self.appointments.append(appointment)
                
//                var customObjects = self.appointments.sorted(by: {
//                    $0.date.compare($1.date) == .orderedDescending
//                })
//
//                print("apptDict array is \(customObjects)")
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
        
        cell.textLabel?.text = appointment.date
        cell.detailTextLabel?.text = appointment.treatment1
        
        print("appt is can = \(appointment.isCancelled)")
        
        
        
        if appointment.isCancelled == true {
            
            let topAttributes: [NSAttributedStringKey: Any] =
                [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 24)!,
                 NSAttributedStringKey.strikethroughStyle: 1]
            
            let bottomAttributes: [NSAttributedStringKey: Any] =
                [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Regular", size: 17)!,
                 NSAttributedStringKey.strikethroughStyle: 1]
            
            let topText = appointment.date + "    " + appointment.treatment1
            let bottomText = appointment.firstName + " " + appointment.lastName
            
            
            cell.textLabel?.attributedText = NSAttributedString(string: topText, attributes: topAttributes)
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.alpha = 0.5
            
            cell.detailTextLabel?.attributedText = NSAttributedString(string: bottomText, attributes: bottomAttributes)
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.detailTextLabel?.alpha = 0.5
            
            cell.backgroundColor = UIColor.darkGray
            
        } else {
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            
        }
        
        
//        let firstName = appointments[indexPath.row].firstName
//        let lastName = appointments[indexPath.row].lastName
//        let date = appointments[indexPath.row].date
//        let treatment = appointments[indexPath.row].treatment1
//        cell.textLabel?.text = date + "    " + treatment
//        cell.detailTextLabel?.text = firstName + " " + lastName
//
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
        
        let adminApptDetailVC = storyboard?.instantiateViewController(withIdentifier: "AdminApptDetailVC") as! AdminApptDetailVC
        
        let appointment: Appointment
        if isFiltering() {
            appointment = filteredAppointments[indexPath.row]
            
        } else {
            appointment = appointments[indexPath.row]
            
        }
        //        print("selected a user \(users[indexPath.row].email)")
//                let firstName = appointment[indexPath.row].firstName
//                let lastName = appointment[indexPath.row].lastName
//                let phoneNumber = appointment[indexPath.row].phoneNumber
//                let email = appointment[indexPath.row].email
//                let treatment = appointment[indexPath.row].treatment1
        //
        //        userDetailVC.clientName = firstName + " " + lastName
        //        userDetailVC.phoneNumber = phoneNumber
        //        userDetailVC.email = email
//        let firstName = appointment.firstName
//        let lastName = appointment.lastName
//        let phoneNumber = appointment.phoneNumber
//        let email = appointment.email
//        let treatment = appointment.treatment1
//        let appointmentDate = appointment.date
   
        self.apptObjectShared.firebaseApptID = appointment.firebaseApptID
        self.apptObjectShared.firebaseClientID = appointment.firebaseClientID
        self.apptObjectShared.isCancelled = appointment.isCancelled
        self.apptObjectShared.isActive = appointment.isActive
        self.apptObjectShared.isComplete = appointment.isComplete
        self.apptObjectShared.firstName = appointment.firstName
        self.apptObjectShared.lastName = appointment.lastName
        self.apptObjectShared.phoneNumber = appointment.phoneNumber
        self.apptObjectShared.email = appointment.email
        self.apptObjectShared.treatment1 = appointment.treatment1
        self.apptObjectShared.date = appointment.date
        self.apptObjectShared.notes = appointment.notes
        
//        adminApptDetailVC.apptDateTime.text = appointmentDate
//        adminApptDetailVC.treatmentLabel.text = treatment
//        adminApptDetailVC.userFullNameLabel.text = firstName + " " + lastName
//        adminApptDetailVC.userPhoneLabel.text = phoneNumber
//        adminApptDetailVC.userEmailLabel.text = email
//        adminApptDetailVC.cancelledBool = listOfAppointmentsVCBool
        navigationController?.pushViewController(adminApptDetailVC, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: nil, message: "Confirm Cancel ? ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                
                performUIUpdatesOnMain {
                    self.listOfAppointmentsVCBool = true
                    tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.red
                    var labelText = tableView.cellForRow(at: indexPath)?.textLabel?.text
                    tableView.cellForRow(at: indexPath)?.textLabel?.text = "\(tableView.cellForRow(at: indexPath)?.textLabel?.text!) CANCELED"
                    tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.red
                    
//                    self.ref.child("client").child("users").child("\(self.users[indexPath.row].firstName) \(self.users[indexPath.row].lastName)").removeValue(completionBlock: { (error, refer) in
//                        if error != nil {
//                            print(error)
//                        } else {
//                            print(refer)
//                            print("Child Removed Correctly")
//                        }
//                    })
//                    self.users.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension ListOfAppointmentsVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
