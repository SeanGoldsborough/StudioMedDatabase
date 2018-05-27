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

class FirstLoginVC: UIViewController, UINavigationControllerDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("error on first loginvc")
    }


   // var signInVariable = userSignedInGlobal

    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func signUp(_ sender: Any) {
            //USES STORYBOARD SEGUE AND ANIMATION
        }

        @IBAction func logInEmail(_ sender: Any) {
//            let firebaseAuth = Auth.auth()
//            do {
//                try firebaseAuth.signOut()
//                print ("google signout okay")
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//            }
        }
    

    
    @IBAction func googleLogin(_ sender: Any) {
       GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
}


