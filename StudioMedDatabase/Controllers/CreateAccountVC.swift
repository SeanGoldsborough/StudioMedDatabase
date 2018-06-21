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
     @IBOutlet weak var scrollView: UIScrollView!
    var activeField: UITextField?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityOverlay: UIView!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var zipCodeText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var keyboardIsShown = false
    
    @IBAction func cancelButton(_ sender: Any) {
        if let viewToAnimate = self.view {
            
            UIView.animate(withDuration: 0.3) {
                viewToAnimate.alpha = 0
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func createAccountButton(_ sender: Any) {
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = false
            self.activityIndicator?.startAnimating()
        }
    
        if firstNameText.text == "" || lastNameText.text == "" || phoneNumberText.text == "" || zipCodeText.text == "" || emailText.text == "" || passwordText.text == "" {
            
            performUIUpdatesOnMain {
                self.activityOverlay?.isHidden = true
                self.activityIndicator?.stopAnimating()
                AlertView.alertPopUp(view: self, alertMessage: "Form not completely filled out!")
            }
            
        } else if zipCodes.sharedInstance.zipCodeArray.contains(self.zipCodeText.text!) == false {
            
            performUIUpdatesOnMain {
                self.activityOverlay?.isHidden = true
                self.activityIndicator?.stopAnimating()
                AlertView.alertPopUp(view: self, alertMessage: "We're sorry but we are not currently servicing your area. Please check back with us soon!")
            }
            
        } else {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
                
                if error == nil {
                    performUIUpdatesOnMain {
                        self.activityOverlay?.isHidden = true
                        self.activityIndicator?.stopAnimating()
                    }
                    print("You have successfully signed up")
                    print(self.userObject.fireBaseUID = Auth.auth().currentUser?.uid)
                   
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
                            "email": "\(self.emailText.text!)", "password": "\(self.passwordText.text!)", "appointments": " ", "allowNotifications": true, "allowEmailNewsletter": true] as [String : Any]
                        let childUpdates = ["/client/clients/\(key)": post]
                        self.ref.updateChildValues(childUpdates)
                        
                        let clientTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientTabVC") as! ClientTabVC
                        
                        self.present(clientTabVC, animated: true)
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.activityOverlay?.isHidden = true
                        self.activityIndicator?.stopAnimating()
                        AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)
                    }
                    
                }
            }         
        }
        print("user array count is: \(userArray.count)")
        print("user object name is: \(userObject.firstName)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = true
            self.activityIndicator?.stopAnimating()
        }
        
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
    
    @objc func changeResponder() {
        var textField: UITextField!
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
            self.view.endEditing(true)
        }
    }
    
    @objc func doneButtonAction() {
        //changeResponder()
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       subscribeToNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
// MARK: - CreateAccountVC (Notifications)

private extension CreateAccountVC {

    func subscribeToNotification(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromAllNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
