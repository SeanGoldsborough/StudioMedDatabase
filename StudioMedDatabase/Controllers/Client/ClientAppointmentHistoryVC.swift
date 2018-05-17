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
    //var arrayOfUsers = [UserData]()
    //var users = UserArray.sharedInstance.listOfUsers
    var userName = String()
    var userNames = [String]()
    var userData = [DataSnapshot]()
    //var postData = ["one", "two", "three"]
    var postData = [UserData]()
    var users = [User]()
    var selectedIndexes = [Int]()
    
    var myBool = false
    var coloredCellIndex = 1000
    
    @IBAction func logOutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                present(loginVC, animated: true, completion: nil)
                print("logout success")
                
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
        
        //navigationController?.navigationBar.isHidden = true
        
        //print(users.count)
        
        if users.count < 1 {
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
        databaseHandle = ref.child("client").child("clients").observe(.childAdded, with: { (snapshot) in
            if let userDict = snapshot.value as? [String : AnyObject] {
                print("userDict is \(userDict)")
                
                let firstNameText = userDict["firstName"] as! String
                let lastNameText = userDict["lastName"] as! String
                let phoneNumberText = userDict["phoneNumber"] as! String
                let zipCodeText = userDict["zipCode"] as! String
                let emailText = userDict["email"] as! String
                


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
        var zip = users[indexPath.row].zipCode
        cell.textLabel?.text = firstName + " " + lastName
        cell.detailTextLabel?.text = phoneNumber + "    " + email
        
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
                let firstName = users[indexPath.row].firstName
                let lastName = users[indexPath.row].lastName
                let phoneNumber = users[indexPath.row].phoneNumber
                let email = users[indexPath.row].email
        
//                apptDetailVC.clientName = firstName + " " + lastName // should be date and time
//                apptDetailVC.phoneNumber = phoneNumber // should be treatment
//                apptDetailVC.email = email // should be notes
        apptDetailVC.coloredCellIndex = indexPath.row
        navigationController?.pushViewController(apptDetailVC, animated: true)
        
    }
}

