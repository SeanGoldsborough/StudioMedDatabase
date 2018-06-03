//
//  EditInfoVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/10/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class EditInfoVC: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var users = [User]()
    var notificationsSwitchBool = false
    var emailSwitchBool = false
    var userApptArray = [""]
    
    var keyboardIsShown = false
    
    
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    //TODO: Fix this so that it updates only the field that was changed and doesnt rewrite the entire object
    @IBAction func submitButton(_ sender: Any) {

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        print("user id is: \(userID).")
        print("FirstNameText is: \(self.firstNameTF.text).")
        print("LastNameText is: \(self.lastNameTF.text).")
        print("email allowed is: \(self.emailAllowedSwitch.isOn).")
        
        let key = ref.child("client").child("clients").child(userID!).key
        let post = [
            
                    "allowEmailNewsletter": self.emailSwitchBool,
                    "allowNotifications": self.notificationsSwitchBool,
                    "appointments": self.userApptArray,
                    "email":"\(self.emailTF.text!)",
                    "fireBaseUID":"\(userID!)",
                    "firstName":"\(self.firstNameTF.text!)",
                    "lastName":"\(self.lastNameTF.text!)",
                    "password":"\(userID!)",
                    "phoneNumber":"\(self.phoneNumberTF.text!)",
                    "zipCode":"\(self.zipCodeTF.text!)"] as [String : Any]

        let childUpdates = ["/client/clients/\(key)": post]//,
                            //"/user-posts/\(userID)/\(key)/": post]
        print("child updates are: \(childUpdates)")
        ref.updateChildValues(childUpdates)
        
        self.navigationController?.popViewController(animated: true)

    }
    
    
    @IBOutlet weak var notificationsAllowedSwitch: UISwitch!
    @IBOutlet weak var emailAllowedSwitch: UISwitch!
    
    @IBAction func notificationsSwitch(_ sender: Any) {
        
        // Get value of "on" to determine current state of UISwitch.
        let onState = notificationsAllowedSwitch.isOn
        
        // Write label text depending on UISwitch.
        if onState {
            self.notificationsSwitchBool = true
        }
        else {
            self.notificationsSwitchBool = false
        }
        
        //var ref: DatabaseReference!
        //ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().root.child("client").child("clients").child(userID!).updateChildValues(["allowNotifications": self.notificationsSwitchBool])
    }
    
    
    @IBAction func newsletterSwitch(_ sender: Any) {
        
        // Get value of "on" to determine current state of UISwitch.
        let onState = notificationsAllowedSwitch.isOn
        
        // Write label text depending on UISwitch.
        if onState {
            self.emailSwitchBool = true
        }
        else {
            self.emailSwitchBool = false
        }
        
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().root.child("client").child("clients").child(userID!).updateChildValues(["allowEmailNewsletter": self.emailSwitchBool])
        
    }
    
    func getOneUserData() {
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        //let userID = "ks5xtiGRZNWfaVvgAtK9zHWekru1"
        ref.child("client").child("clients").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userDict = snapshot.value as? NSDictionary
            let fireBaseUIDText  = userDict!["fireBaseUID"] as! String
            let firstNameText = userDict!["firstName"] as! String
            let lastNameText = userDict!["lastName"] as! String
            let phoneNumberText = userDict!["phoneNumber"] as! String
            let zipCodeText = userDict!["zipCode"] as! String
            let emailText = userDict!["email"] as! String
            let allowNotificationsBool = userDict!["allowNotifications"] as! Bool
            let allowEmailNewsletterBool = userDict!["allowEmailNewsletter"] as! Bool
            //let user = User(username: username)
            print("userDict1 is \(userDict)")
            
            performUIUpdatesOnMain {
                self.firstNameTF.text = firstNameText
                self.lastNameTF.text = lastNameText
                self.phoneNumberTF.text = phoneNumberText
                self.zipCodeTF.text = zipCodeText
                self.emailTF.text = emailText
                self.emailSwitchBool = allowEmailNewsletterBool
                self.notificationsSwitchBool = allowNotificationsBool
                self.emailAllowedSwitch.isOn = self.emailSwitchBool
                self.notificationsAllowedSwitch.isOn = self.notificationsSwitchBool
            }
            // ...
        }) { (error) in
            AlertView.alertPopUp(view: self, alertMessage: "Unable to load data. \(error.localizedDescription)")
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        phoneNumberTF.delegate = self
        emailTF.delegate = self
        zipCodeTF.delegate = self
        getOneUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOneUserData()
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
}
// MARK: - CreateAccountVC: UITextFieldDelegate
extension EditInfoVC: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTF {
            textField.resignFirstResponder()
            lastNameTF.becomeFirstResponder()
        } else if textField == lastNameTF {
            textField.resignFirstResponder()
            phoneNumberTF.becomeFirstResponder()
        } else if textField == phoneNumberTF {
            textField.resignFirstResponder()
            zipCodeTF.becomeFirstResponder()
        } else if textField == zipCodeTF {
            textField.resignFirstResponder()
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    //    // MARK: Show/Hide Keyboard
    //
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardIsShown {
            view.frame.origin.y = -keyboardHeight(notification) / 2.6
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardIsShown {
            view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardIsShown = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardIsShown = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
// MARK: - CreateAccountVC (Notifications)

private extension EditInfoVC {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
