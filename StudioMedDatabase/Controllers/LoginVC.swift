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
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(_ sender: Any) {
        
        if emailTextField.text == "" {
            AlertView.alertPopUp(view: self, alertMessage: "Please enter your email and password")
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
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
    
     @IBAction func signUpButton(_ sender: Any) {
        let createAccountVC = storyboard?.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountVC
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
