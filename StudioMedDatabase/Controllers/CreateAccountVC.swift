//
//  CreateAccountVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CreateAccountVC: UIViewController {
    
    var ref: DatabaseReference!
    
    var userArray: [UserData] = UserArray.sharedInstance.listOfUsers
    var userObject = UserData()
  
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var phoneNumberText: UITextField!
    
    @IBOutlet weak var zipCodeText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    var keyboardIsShown = false

    @IBAction func backButton(_ sender: Any) {
        if let viewToAnimate = self.view {
        
        UIView.animate(withDuration: 0.3) {
            viewToAnimate.alpha = 0
            self.dismiss(animated: true, completion: nil)
        }
//            UIView.animate(withDuration: 5, delay: 0, options: .curveEaseIn, animations: {
//                viewToAnimate.alpha = 0
//            }) { _ in
//                viewToAnimate.removeFromSuperview()
//                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "FirstLoginVC") as! FirstLoginVC
//                self.present(loginVC, animated: true)
//
//            }
        }
    }
    @IBAction func createAccountButton(_ sender: Any) {
        
        
        if firstNameText.text == "" || lastNameText.text == "" || phoneNumberText.text == "" || zipCodeText.text == "" || emailText.text == "" || passwordText.text == "" {
            AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
        } else if zipCodes.sharedInstance.zipCodeArray.contains(self.zipCodeText.text!) == false {
            AlertView.alertPopUp(view: self, alertMessage: "We're sorry but we are not currently servicing your area. Please check back with us soon!")
        } else {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    print(self.userObject.fireBaseUID = Auth.auth().currentUser?.uid)
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    self.userObject.fireBaseUID = Auth.auth().currentUser?.uid
                    self.userObject.firstName = self.firstNameText.text
                    self.userObject.lastName = self.lastNameText.text
                    self.userObject.phoneNumber = self.phoneNumberText.text
                    self.userObject.zipCode = self.zipCodeText.text
                    self.userObject.email = Auth.auth().currentUser?.email
                    self.userObject.password = self.passwordText.text
                    self.userArray.append(self.userObject)
                    
                    if self.firstNameText.text == "" || self.lastNameText.text == "" || self.phoneNumberText.text == "" || self.zipCodeText.text == "" || self.emailText.text == "" || self.passwordText.text == "" {
                        AlertView.alertPopUp(view: self, alertMessage: "Please enter the neccessary info.")
                    
                        
                        } else {
                        let fullName = "\(self.firstNameText.text! + " " + self.lastNameText.text!)"
                        //let key = ref.child("\(fullName)").key
                        let key = self.ref.child(Auth.auth().currentUser!.uid).key
                        let post = ["fireBaseUID": "\(Auth.auth().currentUser!.uid)", "firstName": "\(self.firstNameText.text!)",
                            "lastName": "\(self.lastNameText.text!)",
                            "phoneNumber": "\(self.phoneNumberText.text!)",
                            "zipCode": "\(self.zipCodeText.text!)",
                            "email": "\(self.emailText.text!)", "password": "\(self.passwordText.text!)", "appointments": " "]
                        let childUpdates = ["/client/clients/\(key)": post]
                        self.ref.updateChildValues(childUpdates)
                        
                        let clientTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientTabVC") as! ClientTabVC
                        //listOfAppointmentsVC.userName = fullName
                        
                        self.present(clientTabVC, animated: true)
                        //navigationController?.pushViewController(clientTabVC, animated: true)
                    }
                } else {
                    AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)
                }
            }         
        }
        print("user array count is: \(userArray.count)")
        print("user object name is: \(userObject.firstName)")
       // createAppt()
        //print("createAppt was called")
    }
 
//    func createAppt() {
//        let key = ref.child("\(firstNameText.text! + " " + lastNameText.text!)").child("appointments").childByAutoId().key
//        let post = ["firstName": "\(firstNameText.text!)",
//            "lastName": "\(lastNameText.text!)",
//            "phoneNumber": "\(phoneNumberText.text!)",
//            "email": "\(emailText.text!)"]
//        let childUpdates = ["/client/users/\(firstNameText.text! + " " + lastNameText.text!)`/appointments/\(key)": post]
//        ref.updateChildValues(childUpdates)
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        firstNameText.delegate = self
        lastNameText.delegate = self
        phoneNumberText.delegate = self
        zipCodeText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
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
        self.firstNameText.inputAccessoryView = toolbar
        self.lastNameText.inputAccessoryView = toolbar
        self.phoneNumberText.inputAccessoryView = toolbar
        self.zipCodeText.inputAccessoryView = toolbar
        self.emailText.inputAccessoryView = toolbar
        self.passwordText.inputAccessoryView = toolbar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let conditionRef = ref.child("users")
//        conditionRef.observe(.value, with: (snap: DataSnapshot) -> Void) in
//        self.firstNameText.text = snap.value.description
        //self.ref.child("client").child("users").child("userEmail").child("meaty").child("lastName").removeValue()
        //self.ref.child("client").child(user.uid).setValue(["username": username])
        //self.ref.child("client").child("users").child("userEmail").child("meaty").child("firstName")
       // self.ref.child("client").child("users").child("userEmail").child("meaty").child("lastName")
//        self.ref.child("client").child("users").child("userEmail").child("meaty").setValue(["firstName": "Jenny"])
//        self.ref.child("client").child("users").child("userEmail").child("meaty").setValue(["lastName": "Bae"])
        //print("stuff here is: \(self.ref.child("client").child("users").child("userEmail").child("meaty"))")
        
//        let key = ref.child("meaty").childByAutoId().key
//        let post = ["firstName": "userID",
//                    "lastName": "username",
//                    "phoneNumber": "title",
//                    "email": "body"]
//        let childUpdates = ["/client/users/userEmail/meaty/appointments/\(key)": post]
//        ref.updateChildValues(childUpdates)
//        
//        let key2 = ref.child("appt").childByAutoId().key
//        let post2 = ["date": "02/01/01",
//                     "time": "14:00PM",
//                    "treatment": "stuff",
//                    "location": "in office"]
//        let childUpdates2 = ["/client/users/userEmail/meaty/appointments/appt\(key2)": post2]
//        ref.updateChildValues(childUpdates2)
    }
    
}

// MARK: - CreateAccountVC: UITextFieldDelegate
extension CreateAccountVC: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == firstNameText {
            textField.resignFirstResponder()
            lastNameText.becomeFirstResponder()
        } else if textField == lastNameText {
            textField.resignFirstResponder()
            phoneNumberText.becomeFirstResponder()
        } else if textField == phoneNumberText {
            textField.resignFirstResponder()
            zipCodeText.becomeFirstResponder()
        } else if textField == zipCodeText {
            textField.resignFirstResponder()
            emailText.becomeFirstResponder()
        } else if textField == emailText {
            textField.resignFirstResponder()
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
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

private extension CreateAccountVC {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
