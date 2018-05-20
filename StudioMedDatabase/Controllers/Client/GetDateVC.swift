//
//  GetDateVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/18/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

//protocol GetDataProtocol {
//    func setResultOfGetData(valueSent: String)
//}

class GetDateVC: UIViewController, UITextFieldDelegate {
    
    var delegate:GetDataProtocol?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func sendData(_ sender: Any) {
        delegate?.setResultOfGetDate(valueSent: textField.text!)
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
