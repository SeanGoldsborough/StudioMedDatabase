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

//import AccountKit
//
class FirstLoginVC: UIViewController, UINavigationControllerDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("error on first loginvc")
    }
    

    
    //
    //    // MARK: Properties
    //    fileprivate var accountKit = AKFAccountKit(responseType: .accessToken)
    //    fileprivate var dataEntryViewController: AKFViewController? = nil
    //    fileprivate var showAccountOnAppear = false
    //
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func signUp(_ sender: Any) {
            //USES STORYBOARD SEGUE AND ANIMATION
            
            //FBSDKAppEvents.logEvent("loginWithPhone clicked")
    
//            if let viewController = accountKit.viewControllerForPhoneLogin() as? AKFViewController {
//                prepareDataEntryViewController(viewController)
//                if let viewController = viewController as? UIViewController {
//                    present(viewController, animated: true, completion: nil)
//                }
//            }
        }
    //
        @IBAction func logInEmail(_ sender: Any) {
            //FBSDKAppEvents.logEvent("loginWithEmail clicked")
    
//            if let viewController = accountKit.viewControllerForEmailLogin() as? AKFViewController {
//                prepareDataEntryViewController(viewController)
//                if let viewController = viewController as? UIViewController {
//                    present(viewController, animated: true, completion: nil)
//                }
//            }
        }
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        //let searchVC = self.storyboard!.instantiateViewController(withIdentifier: "SearchVC")
        //navigationController!.pushViewController(searchVC, animated: true)
//        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//            if segue.identifier == "logInSuccess" {
////                if let nextVC = segue.destination as? TabBarController {
////                    //nextVC.selectedBasicPhrase = sender
////                }
//            }
//        }
//        performSegue(withIdentifier: "logInSuccess", sender: Any?.self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        GIDSignIn.sharedInstance().uiDelegate = self

        
        
       
        
        //        showAccountOnAppear = accountKit.currentAccessToken != nil
        //        dataEntryViewController = accountKit.viewControllerForLoginResume() as? AKFViewController
    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        if showAccountOnAppear {
    //            showAccountOnAppear = false
    //            presentWithSegueIdentifier("showAccount", animated: animated)
    //        } else if let viewController = dataEntryViewController {
    //            if let viewController = viewController as? UIViewController {
    //                present(viewController, animated: animated, completion: nil)
    //                dataEntryViewController = nil
    //            }
    //        }
    //
    //        //self.navigationController?.isNavigationBarHidden = true
    //
    //    }
    //
    //
    //    // MARK: Helper Functions
    //
    //    func prepareDataEntryViewController(_ viewController: AKFViewController){
    //        viewController.delegate = self
    //    }
    //
    //    func presentWithSegueIdentifier(_ segueIdentifier: String, animated: Bool) {
    //        if animated {
    //            performSegue(withIdentifier: segueIdentifier, sender: nil)
    //        } else {
    //            UIView.performWithoutAnimation {
    //                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
    //            }
    //        }
    //    }
    //
    //}
    //
    //
    //
    //// MARK: - LogInViewController: AKFViewControllerDelegate
    //extension LogInViewController: AKFViewControllerDelegate {
    //
    //    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken, state: String!) {
    //        presentWithSegueIdentifier("showAccount", animated: false)
    //
    //    }
    //
    //    func viewController(_ viewController: UIViewController, didFailWithError error: Error!) {
    //        print("\(viewController) did fail with error: \(error)")
    //    }
}
//

