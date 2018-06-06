//
//  AddNewAdminVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 6/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddNewAdminVC: UIViewController {
 
    @IBAction func addAdminButton(_ sender: Any) {
        print("add admin button pressed")
        let addNewAdminFormVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAdminFormVC") as! AddNewAdminFormVC
        self.navigationController?.pushViewController(addNewAdminFormVC, animated: true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
