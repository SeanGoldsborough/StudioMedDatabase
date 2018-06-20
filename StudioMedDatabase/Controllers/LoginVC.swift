//
//  LoginVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/7/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    var userObjectShared = UserData.sharedInstance()
    var currentUser = Auth.auth().currentUser?.uid
    var adminUsers = [String]()
    
    var keyboardIsShown = false
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityOverlay: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func getAdminUserID() {
        databaseHandle = ref.child("admin").child("adminUsers").observe(.childAdded, with: { (snapshot) in
            if let userDict = snapshot.value as? [String : AnyObject] {
                let firebaseUID = userDict["fireBaseUID"] as! String
                self.adminUsers.append(firebaseUID)
                print("adminUsers array is \(self.adminUsers)")
            }
        })
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = false
            self.activityIndicator?.startAnimating()
        }
        
        if emailTextField.text == "" {
            performUIUpdatesOnMain {
                self.activityOverlay?.isHidden = true
                self.activityIndicator?.stopAnimating()
                AlertView.alertPopUp(view: self, alertMessage: "Please enter your email and password")
            }
            
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in: \(Auth.auth().currentUser?.uid)")
                    
                    self.currentUser = Auth.auth().currentUser?.uid
                    
                        if self.adminUsers.contains(where: { $0 == Auth.auth().currentUser?.uid }) {

                            let adminTabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientTabVC") as! ClientTabVC
                            self.present(adminTabBarVC, animated: true)
                            
                        } else {

                        //Go to the ClientTabVC if the login is sucessful
                        let clientTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientTabVC") as! ClientTabVC
                        self.present(clientTabVC, animated: true)
                        //self.navigationController?.pushViewController(clientTabVC, animated: true)
                        }
                    
                } else {
                    performUIUpdatesOnMain {
                        self.activityOverlay?.isHidden = true
                        self.activityIndicator?.stopAnimating()
                        //Tells the user that there is an error and then gets firebase to tell them the error
                        AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)
                    }
                    
                }
            }
        }
    }


    @IBAction func forgotPassword(_ sender: Any) {
        let resetPasswordVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
       navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    @IBAction func signUpButton(_ sender: Any) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        performUIUpdatesOnMain {
            
            self.activityOverlay?.isHidden = true
            self.activityIndicator?.stopAnimating()
            
        }
        emailTextField.delegate = self
        passwordTextField.delegate = self
        ref = Database.database().reference()
        getAdminUserID()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        navigationController?.navigationBar.topItem?.title = ""
        
        navigationController?.navigationBar.isHidden = false
        
       let currentUser = Auth.auth().currentUser
        print("currentUser on login with email page is: \(currentUser)")
    }
}

// MARK: - LoginVC: UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
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
// MARK: - LoginVC (Notifications)

private extension LoginVC {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
