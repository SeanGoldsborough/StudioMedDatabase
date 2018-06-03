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
    
    var keyboardIsShown = false
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(_ sender: Any) {
        
        if emailTextField.text == "" {
            AlertView.alertPopUp(view: self, alertMessage: "Please enter your email and password")
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in: \(Auth.auth().currentUser?.uid)")
                    //self.userObjectShared.firstName = Auth.auth().currentUser?.displayName
                    self.currentUser = Auth.auth().currentUser?.uid
                    

                    //Go to the ClientTabVC if the login is sucessful
                    let clientTabVC = self.storyboard?.instantiateViewController(withIdentifier: "ClientTabVC") as! ClientTabVC
                    self.present(clientTabVC, animated: true)
                    
                } else {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)
                }
            }
        }
    }

    @IBAction func dontHaveAccountButton(_ sender: Any) {
        let createAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        self.present(createAccountVC, animated: true, completion: nil)
        }

    @IBAction func adminButton(_ sender: Any) {
        print("admin button pressed")
    }
    
    @IBAction func loginButton(_ sender: Any) {
        print("login button pressed")
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let resetPasswordVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        self.present(resetPasswordVC, animated: true, completion: nil)
    }
    @IBAction func signUpButton(_ sender: Any) {
        let createAccountVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        ref = Database.database().reference()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
        //emailTextField.tag = 0
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

// MARK: - LoginVC: UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        emailTextField?.resignFirstResponder()
//        passwordTextField?.resignFirstResponder()
//        return true
        
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
