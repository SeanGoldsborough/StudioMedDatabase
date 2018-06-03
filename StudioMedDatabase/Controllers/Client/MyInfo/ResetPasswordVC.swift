//
//  ResetPasswordVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class  ResetPasswordVC: UIViewController {
    
    var keyboardIsShown = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resetPasswordButton(_ sender: Any) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        self.emailTextField.delegate = self
        
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
        self.emailTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }   
}

// MARK: - CreateAccountVC: UITextFieldDelegate
extension ResetPasswordVC: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        
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

private extension ResetPasswordVC {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
