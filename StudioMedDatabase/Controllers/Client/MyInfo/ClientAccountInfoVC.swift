//
//  ClientAccountInfoVC.swift
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

class ClientAccountInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func resetPasswordButton(_ sender: Any) {
        
        let resetPasswordVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }

    @IBOutlet weak var tableView: UITableView!
    
    let clientInfoArray = ["ClientDataGoesHere", "Update MyInfo", "Reset Password", "Privacy Policy", "Terms of Service"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.text = clientInfoArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("it works?")
        print(indexPath)
        switch indexPath.row {
        case 0:
            print("it works?")
        case 1:
            let editInfoVC = storyboard?.instantiateViewController(withIdentifier: "EditInfoVC") as! EditInfoVC
            navigationController?.pushViewController(editInfoVC, animated: true)
        case 2:
            let resetPasswordVC = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
            navigationController?.pushViewController(resetPasswordVC, animated: true)
        case 3:
            let privacyPolicyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
        case 4:
            let termsOfServiceVC = storyboard?.instantiateViewController(withIdentifier: "TermsOfServiceVC") as! TermsOfServiceVC
            navigationController?.pushViewController(termsOfServiceVC, animated: true)
        default:
            break;
        }
    }
}