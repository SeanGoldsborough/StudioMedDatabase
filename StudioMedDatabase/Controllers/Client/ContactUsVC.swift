//
//  ContactUsVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/10/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ContactUsVC: UIViewController {
    
    @IBAction func callUsButton(_ sender: Any) {
        print("call client button pressed!")
        
        if let call = "16103283169" as? String {
            let url = URL(string: "tel://\(call)")
            UIApplication.shared.open(url!)
        }
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
