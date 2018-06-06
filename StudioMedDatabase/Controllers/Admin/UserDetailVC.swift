//
//  UserDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Firebase

class UserDetailVC: UIViewController {
    
    var userID = String()
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    var zipCode = String()
    var email = String()
    
    @IBOutlet weak var clientNameLabel: UITextField!
    
     @IBOutlet weak var clientLastNameLabel: UITextField!
    
    @IBOutlet weak var clientPhoneLabel: UITextField!
    
    @IBOutlet weak var clientZipCodeLabel: UITextField!
    
    @IBOutlet weak var clientEmailLabel: UITextField!

    @IBOutlet weak var callClient: UIButton!
    
    @IBOutlet weak var emailClient: UIButton!
    
    
    
    @IBAction func previousApptsButton(_ sender: Any) {
        print("prev appts button pressed!")
        let previousApptsVC = storyboard?.instantiateViewController(withIdentifier: "PreviousApptsVC") as! PreviousApptsVC
        previousApptsVC.userID = self.userID
        navigationController?.pushViewController(previousApptsVC, animated: true)
    }
    
    @IBAction func callClientButton(_ sender: Any) {
         print("call client button pressed!")
//        let url = URL(string: "telprompt://1\(clientPhoneLabel.text!)")!
//        let url = URL(string: "telprompt://12156883043)")!
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
//
        if let call = clientPhoneLabel.text as? String {
            let url = URL(string: "tel://\(call)")
            UIApplication.shared.open(url!)
//            UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
        }
        
        print("telprompt://\(clientPhoneLabel.text!)")
        
    }
    
    
    @IBAction func emailClientButton(_ sender: Any) {
         print("email button pressed!")
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendEmail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clientName = firstName + " " + lastName
        self.title = clientName
        clientNameLabel.text = firstName
        clientLastNameLabel.text = lastName
        clientPhoneLabel.text = phoneNumber
        clientZipCodeLabel.text = zipCode
        clientEmailLabel.text = email

        callClient.setTitle("Call \(firstName)", for: .normal)
        emailClient.setTitle("Email \(firstName)", for: .normal)
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        //composeVC.mailComposeDelegate = self
        composeVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
        // Configure the fields of the interface.
        composeVC.setToRecipients(["\(email)"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        if result == .cancelled {
            controller.dismiss(animated: true, completion: nil)
        } else if result == .sent {
            controller.dismiss(animated: true, completion: nil)
        } else if result == .saved {
            controller.dismiss(animated: true, completion: nil)
        }
    }   
}

//extension UIViewController: MFMailComposeViewControllerDelegate {
//    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}

