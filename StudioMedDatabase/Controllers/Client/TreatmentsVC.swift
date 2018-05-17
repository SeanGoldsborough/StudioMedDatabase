//
//  TreatmentsVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/11/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TreatmentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    //var arrayOfUsers = [UserData]()
    //var users = UserArray.sharedInstance.listOfUsers
    var userName = String()
    var userNames = [String]()
    var userData = [DataSnapshot]()
    //var postData = ["one", "two", "three"]
    var postData = [UserData]()
    var treatments = [Treatment]()
    //var treatmentCatName = String()
    var selectedIndex = Int()
    var treatmentCatName = ["ivTherapy", "urgentCare", "houseCalls", "telemedicine"]
    
    @IBAction func logoutButton(_ sender: Any) {
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
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("user name is: \(userName)")
        tableView.dataSource = self
        tableView.delegate = self
        //print(users.count)
        
        if treatments.count < 1 {
            
            getData()
        }
        
        //        var user = User(firstNameText: "test", lastNameText: "test")
        //        print("user object fn is: \(user.firstName)")
        //        print("user object ln is: \(user.lastName)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if treatments == nil {
            //getData()
        }
        
        
        //let query = ref.queryOrderedByKey() /*or a more sophisticated query of your choice*/
        
        
    }
    
    func getData() {
        databaseHandle = ref.child("treatments").child("\(treatmentCatName[selectedIndex])").observe(.childAdded, with: { (snapshot) in
            if let treatmentDict = snapshot.value as? [String : AnyObject] {

                let treatmentNameText = treatmentDict["name"] as! String
                let aboutText = treatmentDict["about"] as! String
                let priceNumberText = treatmentDict["price"] as! String
                let bestForText = treatmentDict["bestFor"] as! String

                print("treatmentNameText is: \(treatmentNameText)")

                
                let treatment = Treatment(nameText: treatmentNameText, aboutText: aboutText, priceText: priceNumberText, bestForText: bestForText)
                print("treatmentDict is \(treatmentDict)")
                self.treatments.append(treatment)
//                print("users array is \(self.users)")
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(treatments.count)
        return treatments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        let treatmentName = treatments[indexPath.row].name
        let treatmentBestFor = treatments[indexPath.row].bestFor
        print("treatmentNameText is: \(treatmentName)")

//        let lastName = users[indexPath.row].lastName
//        let phoneNumber = users[indexPath.row].phoneNumber
//        let email = users[indexPath.row].email
        cell.textLabel?.text = treatmentName
        cell.detailTextLabel?.text = treatmentBestFor
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
        
        let treatmentDetailVC = storyboard?.instantiateViewController(withIdentifier: "TreatmentDetailVC") as! TreatmentDetailVC
        //        print("selected a user \(users[indexPath.row].email)")
                let treatmentName = treatments[indexPath.row].name
                let treatmentAbout = treatments[indexPath.row].about
        //        let phoneNumber = users[indexPath.row].phoneNumber
        //        let email = users[indexPath.row].email
        //
        //        userDetailVC.clientName = firstName + " " + lastName
        //        userDetailVC.phoneNumber = phoneNumber
        //        userDetailVC.email = email
        //adminApptDetailVC.cancelledBool = listOfAppointmentsVCBool
        treatmentDetailVC.name = treatmentName
        treatmentDetailVC.about = treatmentAbout
        navigationController?.pushViewController(treatmentDetailVC, animated: true)
        
    }
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
//    // Override to support editing the table view.
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let alert = UIAlertController(title: nil, message: "Confirm Delete ? ", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
//
//                performUIUpdatesOnMain {
//
//
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
//                }
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
}
