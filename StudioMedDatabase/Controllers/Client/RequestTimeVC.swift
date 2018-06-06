//
//  RequestTimeVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/19/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//
//
//  ClientAppointmentHistoryVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.

import UIKit
import Firebase


class RequestTimeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var userName = String()
    var userNames = [String]()
    var userData = [DataSnapshot]()
    var timeData = ["09:00 A.M.", "09:30 A.M.","10:00 A.M.", "10:30 A.M.", "11:00 A.M.", "11:30 A.M.", "12:00 P.M.", "12:30 P.M.", "01:00 P.M.", "01:30 P.M.", "02:00 P.M.", "02:30 P.M.", "03:00 P.M.", "03:30 P.M.", "04:00 P.M.", "04:30 P.M.", "05:00 P.M.", "05:30 P.M.", "06:00 P.M.", "06:30 P.M.", "07:00 P.M.", "07:30 P.M.", "08:00 P.M.", "08:30 P.M.", "09:00 P.M.", "09:30 P.M.", "10:00 P.M.", "10:30 P.M.", "11:00 P.M.", "11:30 P.M.", "12:00 A.M.", "12:30 A.M.", "01:00 A.M.", "01:30 A.M.", "02:00 A.M.", "02:30 A.M.", "03:00 A.M.", "03:30 A.M.", "04:00 A.M.", "04:30 A.M.", "05:00 A.M.", "05:30 A.M.", "06:00 A.M.", "06:30 A.M.", "07:00 A.M.", "07:30 A.M.", "08:00 A.M.", "08:30 A.M."]
   
    var appointment = AppointmentData.sharedInstance
    
    var myBool = false
    var coloredCellIndex = 1000
    @IBAction func requestTime(_ sender: Any) {
        //let apptDetailVC = storyboard?.instantiateViewController(withIdentifier: "ApptDetailVC") as! ApptDetailVC
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        
    }
    
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
        
//        if users.count < 1 {
//            getData()
//        }
        
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
    
//    func getData() {
//        databaseHandle = ref.child("client").child("clients").observe(.childAdded, with: { (snapshot) in
//            if let userDict = snapshot.value as? [String : AnyObject] {
//                print("userDict is \(userDict)")
//
//                let firstNameText = userDict["firstName"] as! String
//                let lastNameText = userDict["lastName"] as! String
//                let phoneNumberText = userDict["phoneNumber"] as! String
//                let zipCodeText = userDict["zipCode"] as! String
//                let emailText = userDict["email"] as! String
//
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        let time = timeData[indexPath.row]
        
        cell.textLabel?.text = time
        //cell.detailTextLabel?.text = phoneNumber + "    " + email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chosenTime = timeData[indexPath.row]
        appointment.time = chosenTime
  
    }
}


