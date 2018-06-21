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
    
    @IBOutlet weak var activityOverlay: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = false
            self.activityIndicator?.startAnimating()
            //            AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
        }
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

                print("treatmentVC treatmentNameText is: \(treatmentNameText)")

                
                let treatment = Treatment(nameText: treatmentNameText, aboutText: aboutText, priceText: priceNumberText, bestForText: bestForText)
                print("treatmentVC treatmentDict is \(treatmentDict)")
                self.treatments.append(treatment)

                performUIUpdatesOnMain {
                    self.activityOverlay?.isHidden = true
                    self.activityIndicator?.stopAnimating()
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
        print("treatmentVC cellfor row treatmentNameText is: \(treatmentName)")

        cell.textLabel?.text = treatmentName
        cell.detailTextLabel?.text = treatmentBestFor

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let treatmentDetailVC = storyboard?.instantiateViewController(withIdentifier: "TreatmentDetailVC") as! TreatmentDetailVC

                let treatmentName = treatments[indexPath.row].name
                let treatmentAbout = treatments[indexPath.row].about
         print("treatmentVC didSelectRowAt treatmentNameText is: \(treatmentName)")
        
        treatmentDetailVC.name = treatmentName
        treatmentDetailVC.about = treatmentAbout
        navigationController?.pushViewController(treatmentDetailVC, animated: true)
        
    }
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}
