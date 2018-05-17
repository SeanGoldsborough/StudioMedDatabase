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
    var users = [User]()
    var listOfAppointmentsVCBool = false

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
        
        if users.count < 1 {
            getData()
        }
        
        navigationController?.navigationItem.title = "Hi, \(userName)"
        
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
    
    func getData() {
        databaseHandle = ref.child("client").child("users").observe(.childAdded, with: { (snapshot) in
            if let userDict = snapshot.value as? [String : AnyObject] {
                
                let firstNameText = userDict["firstName"] as! String
                let lastNameText = userDict["lastName"] as! String
                let phoneNumberText = userDict["phoneNumber"] as! String
                let emailText = userDict["email"] as! String
                let zipCodeText = userDict["zipCode"] as! String
                
                
                let user = User(firstNameText: firstNameText, lastNameText: lastNameText, phoneNumberText: phoneNumberText, emailText: emailText, zipCodeText: zipCodeText)
                print("userDict is \(userDict)")
                self.users.append(user)
                print("users array is \(self.users)")
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        let firstName = users[indexPath.row].firstName
        let lastName = users[indexPath.row].lastName
        let phoneNumber = users[indexPath.row].phoneNumber
        let email = users[indexPath.row].email
        cell.textLabel?.text = firstName + " " + lastName
        cell.detailTextLabel?.text = phoneNumber + "    " + email
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
        //        print("selected a user \(users[indexPath.row].email)")
        //        let firstName = users[indexPath.row].firstName
        //        let lastName = users[indexPath.row].lastName
        //        let phoneNumber = users[indexPath.row].phoneNumber
        //        let email = users[indexPath.row].email
        //
        //        userDetailVC.clientName = firstName + " " + lastName
        //        userDetailVC.phoneNumber = phoneNumber
        //        userDetailVC.email = email
        adminApptDetailVC.cancelledBool = listOfAppointmentsVCBool
        navigationController?.pushViewController(adminApptDetailVC, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
