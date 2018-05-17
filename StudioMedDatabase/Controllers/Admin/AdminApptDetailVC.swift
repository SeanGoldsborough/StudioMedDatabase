//
//  AdminApptDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class AdminApptDetailVC: UIViewController {
    
    @IBOutlet weak var cancelledLabel: UILabel!
    var cancelledBool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if cancelledBool == true {
            cancelledLabel.isHidden = false
        } else {
            cancelledLabel.isHidden = true
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
