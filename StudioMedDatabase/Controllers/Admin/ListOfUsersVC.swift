//
//  ListOfUsersVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ListOfUsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    //var arrayOfUsers = [UserData]()
    //var users = UserArray.sharedInstance.listOfUsers
    var userName = String()
    var userNames = [String]()
    //var userData = [DataSnapshot]()
    var userObject = UserData.sharedInstance()
    //var postData = [UserData]()
    var users = [User]()
    var filteredUsers = [User]()
    
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
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Client By Surname"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //navigationController?.navigationBar.topItem?.title = "Hi, \(userObject.firstName!)"
        
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
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredUsers = users.filter({( user : User) -> Bool in
            return user.lastName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
   
    func getData() {
        //let userID = Auth.auth().currentUser
        databaseHandle = ref.child("client").child("clients").observe(.childAdded, with: { (snapshot) in
            if let userDict = snapshot.value as? [String : AnyObject] {
                
                let firstNameText = userDict["firstName"] as! String
                let lastNameText = userDict["lastName"] as! String
                let phoneNumberText = userDict["phoneNumber"] as! String
                let emailText = userDict["email"] as! String
                let zipCodeText = userDict["zipCode"] as! String
                self.userName = firstNameText + " " + lastNameText
                print("user name is: \(self.userName)")
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
        if isFiltering() {
            return filteredUsers.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        
        let user: User
        if isFiltering() {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
//        let firstName = users[indexPath.row].firstName
//        let lastName = users[indexPath.row].lastName
//        let phoneNumber = users[indexPath.row].phoneNumber
//        let email = users[indexPath.row].email
        cell.textLabel?.text = user.firstName + " " + user.lastName
        cell.detailTextLabel?.text = user.phoneNumber + "    " + user.email
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
    
    //TODO: make this work with filteredUsers
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userDetailVC = storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        
        let user: User
        if isFiltering() {
            user = filteredUsers[indexPath.row]
            print("selected a user \(filteredUsers[indexPath.row].email)")
//            let firstName = filteredUsers[indexPath.row].firstName
//            let lastName = filteredUsers[indexPath.row].lastName
//            let phoneNumber = filteredUsers[indexPath.row].phoneNumber
//            let email = filteredUsers[indexPath.row].email
            
        } else {
            user = users[indexPath.row]
            print("selected a user \(users[indexPath.row].email)")
//            let firstName = users[indexPath.row].firstName
//            let lastName = users[indexPath.row].lastName
//            let phoneNumber = users[indexPath.row].phoneNumber
//            let email = users[indexPath.row].email
        }
//        print("selected a user \(users[indexPath.row].email)")
//        let firstName = users[indexPath.row].firstName
//        let lastName = users[indexPath.row].lastName
//        let phoneNumber = users[indexPath.row].phoneNumber
//        let email = users[indexPath.row].email
        
        userDetailVC.firstName = user.firstName
        userDetailVC.lastName = user.lastName
        userDetailVC.phoneNumber = user.phoneNumber
        userDetailVC.email = user.email
        userDetailVC.zipCode = user.zipCode
        
        navigationController?.pushViewController(userDetailVC, animated: true)
        
    }
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: nil, message: "Confirm Delete ? ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in

                performUIUpdatesOnMain {
                    
                    
    self.ref.child("client").child("users").child("\(self.users[indexPath.row].firstName) \(self.users[indexPath.row].lastName)").removeValue(completionBlock: { (error, refer) in
                        if error != nil {
                            print(error)
                        } else {
                            print(refer)
                            print("Child Removed Correctly")
                        }
                    })
                    self.users.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
  
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

extension ListOfUsersVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
