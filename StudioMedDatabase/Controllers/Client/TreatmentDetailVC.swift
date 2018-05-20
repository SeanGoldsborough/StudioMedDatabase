//
//  TreatmentDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/11/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TreatmentDetailVC: UIViewController, UITextViewDelegate {
    var name: String?
    var about: String?
    var appointment = AppointmentData.sharedInstance()
    
    var delegate:GetDataProtocol?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
//
    @IBAction func selectTreatmentButton(_ sender: Any) {
        //pop back 2 views and make either an appt object and then populate the treatment1 with thelabel text or just the text field in the create appt vc
 
        delegate?.setResultOfGetTreatment(valueSent: name!)
        print("the name label text is \(nameLabel.text)")
        appointment.treatment1 = nameLabel.text!
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    
//    class func popToAddLocationVC(view: UIViewController){
//
//        let alertVC = UIAlertController(title: "Could not load location".capitalized, message: "Please try again.", preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "OK", style:.default, handler: {(action) -> Void in
//            let viewControllers: [UIViewController] = view.navigationController!.viewControllers as [UIViewController];
//            view.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
//        })
//
//        alertVC.addAction(okAction)
//
//        view.present(alertVC, animated: true, completion: nil)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name!
        textView.text = about!
        print("name = \(name)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
