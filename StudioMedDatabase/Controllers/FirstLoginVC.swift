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



class FirstLoginVC: UIViewController, UINavigationControllerDelegate  {
    
    @IBOutlet weak var activityOverlay: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


   @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signUp(_ sender: Any) {
            //USES STORYBOARD SEGUE AND ANIMATION
        }

        @IBAction func logInEmail(_ sender: Any) {
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            
            navigationController?.pushViewController(loginVC, animated: true)
        }
    

    
    @IBAction func googleLogin(_ sender: Any) {

      
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.activityOverlay.isHidden = true
        self.activityIndicator.isHidden = true
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.navigationBar.isHidden = true
    }
}


