//
//  FirstLoginVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/10/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn


class FirstLoginVC: UIViewController, UINavigationControllerDelegate, GIDSignInDelegate  {
    
    @IBOutlet weak var activityOverlay: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user:
        GIDGoogleUser!, withError error: Error!) {

                performUIUpdatesOnMain {
                    self.activityOverlay.isHidden = true
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }

        print("error on first loginvc")
        //AlertView.alertPopUp(view: self, alertMessage: "Error: \(error)")
    }

   // var signInVariable = userSignedInGlobal

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func signUp(_ sender: Any) {
            //USES STORYBOARD SEGUE AND ANIMATION
        }

        @IBAction func logInEmail(_ sender: Any) {
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            
            navigationController?.pushViewController(loginVC, animated: true)
        }
    

    
    @IBAction func googleLogin(_ sender: Any) {
//        performUIUpdatesOnMain {
//            self.activityOverlay.isHidden = false
//            self.activityIndicator.isHidden = false
//            self.activityIndicator.startAnimating()
//        }
       GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.activityOverlay.isHidden = true
        self.activityIndicator.isHidden = true
        
        GIDSignIn.sharedInstance().uiDelegate = self as! GIDSignInUIDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.navigationBar.isHidden = true
    }
}


