//
//  UserDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserDetailVC: UIViewController {
    
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    var email = String()
    
    @IBOutlet weak var clientNameLabel: UILabel!
    
    @IBOutlet weak var clientPhoneLabel: UILabel!
    
    @IBOutlet weak var clientEmailLabel: UILabel!
    
    
    @IBOutlet weak var callClient: UIButton!
    
    @IBOutlet weak var emailClient: UIButton!
    
    
    
    @IBAction func previousApptsButton(_ sender: Any) {
        print("prev appts button pressed!")
        let previousApptsVC = storyboard?.instantiateViewController(withIdentifier: "PreviousApptsVC") as! PreviousApptsVC
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clientName = firstName + " " + lastName
        self.title = clientName
        clientNameLabel.text = clientName
        clientPhoneLabel.text = phoneNumber
        clientEmailLabel.text = email

        callClient.setTitle("Call \(firstName)", for: .normal)
        emailClient.setTitle("Email \(firstName)", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
