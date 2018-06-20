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
    var activeField: UITextField?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityOverlay: UIView!
    //TODO: Fix this so that it updates only the field that was changed and doesnt rewrite the entire object
    @IBAction func submitButton(_ sender: Any) {
        
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = false
            self.activityIndicator?.startAnimating()
        }
        

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let refFirstName = Database.database().reference().root.child("client").child("clients").child(userID!).updateChildValues(["firstName": self.firstNameTF.text])
        
        let refLastName = Database.database().reference().root.child("client").child("clients").child(userID!).updateChildValues(["lastName": self.lastNameTF.text!])
        
        let refPhone = Database.database().reference().root.child("client").child("clients").child(userID!).updateChildValues(["phoneNumber": self.phoneNumberTF.text!])
        
        let refZip = Database.database().reference().root.child("client").child("clients").child(userID!).updateChildValues(["zipCode": self.zipCodeTF.text!])
        
        let refEmail = Database.database().reference().root.child("client").child("clients").child(userID!).updateChildValues(["email": self.emailTF.text!])
        
        print("user id is: \(userID).")
        print("FirstNameText is: \(self.firstNameTF.text).")
        print("LastNameText is: \(self.lastNameTF.text).")
        print("email allowed is: \(self.emailAllowedSwitch.isOn).")
        
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = true
            self.activityIndicator?.stopAnimating()
//            AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
        }
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
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = true
            self.activityIndicator?.stopAnimating()
        }
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        phoneNumberTF.delegate = self
        emailTF.delegate = self
        zipCodeTF.delegate = self

        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneBtn.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.black
        toolbar.isTranslucent = true
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        //setting toolbar as inputAccessoryView
        self.firstNameTF.inputAccessoryView = toolbar
        self.lastNameTF.inputAccessoryView = toolbar
        self.phoneNumberTF.inputAccessoryView = toolbar
        self.zipCodeTF.inputAccessoryView = toolbar
        self.emailTF.inputAccessoryView = toolbar
        
        getOneUserData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOneUserData()
        
         subscribeToNotification()
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
}
//// MARK: - CreateAccountVC: UITextFieldDelegate
//extension EditInfoVC: UITextFieldDelegate {
//
//    // MARK: UITextFieldDelegate
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        if textField == firstNameTF {
//            textField.resignFirstResponder()
//            lastNameTF.becomeFirstResponder()
//        } else if textField == lastNameTF {
//            textField.resignFirstResponder()
//            phoneNumberTF.becomeFirstResponder()
//        } else if textField == phoneNumberTF {
//            textField.resignFirstResponder()
//            zipCodeTF.becomeFirstResponder()
//        } else if textField == zipCodeTF {
//            textField.resignFirstResponder()
//            emailTF.becomeFirstResponder()
//        } else if textField == emailTF {
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//
//
//    //    // MARK: Show/Hide Keyboard
//    //
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if !keyboardIsShown {
//            view.frame.origin.y = -keyboardHeight(notification) / 2.6
//        }
//    }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        if keyboardIsShown {
//            view.frame.origin.y = 0
//        }
//    }
//
//    @objc func keyboardDidShow(_ notification: Notification) {
//        keyboardIsShown = true
//    }
//
//    @objc func keyboardDidHide(_ notification: Notification) {
//        keyboardIsShown = false
//    }
//
//    func keyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = (notification as NSNotification).userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
//}

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
//            passwordTF.becomeFirstResponder()
        } //else if textField == passwordTF {
//            textField.resignFirstResponder()
//        }
        return true
    }
    
    
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = ((info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height)! + 160.0
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize + 200
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
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
//// MARK: - EditInfoVC (Notifications)
//
//private extension EditInfoVC {
//
//    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
//        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
//    }
//
//    func unsubscribeFromAllNotifications() {
//        NotificationCenter.default.removeObserver(self)
//    }
//}

// MARK: - EditInfoVC (Notifications)

private extension EditInfoVC {
    
    //    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
    //        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    //    }
    func subscribeToNotification(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    //    func unsubscribeFromAllNotifications() {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    func unsubscribeFromAllNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

