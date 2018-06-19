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
import FirebaseCore
import FirebaseDatabase

class TreatmentsCatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    //var arrayOfUsers = [UserData]()
    //var users = UserArray.sharedInstance.listOfUsers
    var userName = String()
    var userNames = [String]()
    var userData = [DataSnapshot]()
    var postData = [UserData]()
    var treatments = [Treatment]()
    var treatmentCat = [String]()
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
        navigationItem.backBarButtonItem?.image = #imageLiteral(resourceName: "ArrowLeftShape")
        navigationItem.backBarButtonItem?.title = ""
        tableView.dataSource = self
        tableView.delegate = self
        //print(users.count)
        //getData()
        if treatmentCat.count < 1 {
            getData()
        }
        
        //        var user = User(firstNameText: "test", lastNameText: "test")
        //        print("user object fn is: \(user.firstName)")
        //        print("user object ln is: \(user.lastName)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if treatmentCat == nil {
            //getData()
        }
        
        
        //let query = ref.queryOrderedByKey() /*or a more sophisticated query of your choice*/
        
        
    }
    
    func getData() {
        databaseHandle = ref.child("treatments").child("treatmentCat").observe(.childAdded, with: { (snapshot) in
            
            if let treatmentDict = snapshot.value as? [String : AnyObject] {
                
                let treatmentOneText = treatmentDict["ivTherapy"] as! String
                let treatmentTwoText = treatmentDict["urgentCare"] as! String
                let treatmentThreeText = treatmentDict["houseCalls"] as! String
                let treatmentFourText = treatmentDict["telemedicine"] as! String
                print("treatmentDict is \(treatmentDict.keys)")
                self.treatmentCat.append(treatmentOneText)
                self.treatmentCat.append(treatmentTwoText)
                self.treatmentCat.append(treatmentThreeText)
                self.treatmentCat.append(treatmentFourText)
 
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
        print(treatmentCat.count)
        return treatmentCat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        let treatmentName = treatmentCat[indexPath.row]
        //let treatmentBestFor = treatments[indexPath.row].bestFor
        print("treatmentNameText is: \(treatmentName)")
        
        //        let lastName = users[indexPath.row].lastName
        //        let phoneNumber = users[indexPath.row].phoneNumber
        //        let email = users[indexPath.row].email
        cell.textLabel?.text = treatmentName
        //cell.detailTextLabel?.text = treatmentBestFor
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
        
        print("did select row at \(indexPath.row)")
        
        switch indexPath.row {
            case 0:
                let treatmentsVC = storyboard?.instantiateViewController(withIdentifier: "TreatmentsVC") as! TreatmentsVC
                navigationController?.pushViewController(treatmentsVC, animated: true);
            case 1:
                let treatmentDetailVC = storyboard?.instantiateViewController(withIdentifier: "TreatmentDetailVC") as! TreatmentDetailVC
                treatmentDetailVC.name = treatmentCat[1]
                treatmentDetailVC.selectedIndex = 1
                
                navigationController?.pushViewController(treatmentDetailVC, animated: true);
            case 2:
                let treatmentDetailVC = storyboard?.instantiateViewController(withIdentifier: "TreatmentDetailVC") as! TreatmentDetailVC
                treatmentDetailVC.name = treatmentCat[2]
                treatmentDetailVC.selectedIndex = 2
                navigationController?.pushViewController(treatmentDetailVC, animated: true);
            case 3:
                let contactUsVC = storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                navigationController?.pushViewController(contactUsVC, animated: true);
            default:
                break;
        }
    }
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

