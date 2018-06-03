//
//  ContactUsVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/10/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Firebase

class ContactUsVC: UIViewController {
    
    @IBAction func callUsButton(_ sender: Any) {
        print("call client button pressed!")
        
        if let call = "16103283169" as? String {
            let url = URL(string: "tel://\(call)")
            UIApplication.shared.open(url!)
        }
    }
    
    @IBAction func emailButton(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        sendEmail()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        //composeVC.mailComposeDelegate = self
        composeVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
        // Configure the fields of the interface.
        composeVC.setToRecipients(["smgoldsborough@gmail.com"])
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

extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
