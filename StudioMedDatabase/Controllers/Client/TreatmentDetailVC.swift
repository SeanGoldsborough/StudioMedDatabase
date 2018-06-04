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
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    //var treatment = Treatment()
    var treatments = [Treatment]()
    var selectedIndex = Int()
    var treatmentCatName = ["ivTherapy", "urgentCare", "houseCalls"]
    
    var delegate:GetDataProtocol?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var selectButton: UIButton!
    //
    @IBAction func selectTreatmentButton(_ sender: Any) {
        //pop back 2 views and make either an appt object and then populate the treatment1 with thelabel text or just the text field in the create appt vc
 
       // delegate?.setResultOfGetTreatment(valueSent: name!)
        print("the name label text is \(nameLabel.text)")
        appointment.treatment1 = nameLabel.text!
        var vcCount = 4
        if selectedIndex == 1 || selectedIndex == 2 {
            vcCount = 3
        }
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        navigationController!.popToViewController(viewControllers[viewControllers.count - vcCount], animated: true)
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
    func getDataForInfusion() {
        var ref: DatabaseReference!
        var databaseHandle: DatabaseHandle!
        ref = Database.database().reference()
        databaseHandle = ref.child("treatments").child("\(treatmentCatName[selectedIndex])").observe(.childAdded, with: { (snapshot) in
            if let treatmentDict = snapshot.value as? [String : AnyObject] {
                print("data for iv data base handle \(databaseHandle)")
                let treatmentNameText = treatmentDict["name"] as! String
                let aboutText = treatmentDict["about"] as! String
                let priceNumberText = treatmentDict["price"] as! String
                let bestForText = treatmentDict["bestFor"] as! String
                
                print("data for iv treatmentNameText treatment detail vc is: \(treatmentNameText)")
                
                
                let treatment = Treatment(nameText: treatmentNameText, aboutText: aboutText, priceText: priceNumberText, bestForText: bestForText)
                print("data for ivtreatmentDict is \(treatmentDict)")
//                self.name = treatment.name
//                self.about = treatment.about
                self.treatments.append(treatment)
                //                print("users array is \(self.users)")
                performUIUpdatesOnMain {
                    //self.textView.reloadData()
                    self.nameLabel.text = self.name!
                    self.textView.text = self.about!
                    print("data for iv name = \(self.name)")
                    self.selectButton.setTitle("Select \(self.name!)", for: UIControlState.normal)
                }
            }
            //self.tableView.reloadData()
        })
    }
    
    func getData() {
         print("data for others called")
        var ref: DatabaseReference!
        var databaseHandle: DatabaseHandle!
        ref = Database.database().reference()
        print("get data for others treatment cat name is: \(treatmentCatName[selectedIndex])")
        databaseHandle = ref.child("treatments").child("\(treatmentCatName[selectedIndex])").observe(.childAdded, with: { (snapshot) in
            if let treatmentDict = snapshot.value as? [String : AnyObject] {
                print("data for others called data base handle \(databaseHandle)")
                let treatmentNameText = treatmentDict["name"] as! String
                let aboutText = treatmentDict["about"] as! String
                let priceNumberText = treatmentDict["price"] as! String
                let bestForText = treatmentDict["bestFor"] as! String
                
                print("data for others called treatmentNameText treatment detail vc is: \(treatmentNameText)")
             
                let treatment = Treatment(nameText: treatmentNameText, aboutText: aboutText, priceText: priceNumberText, bestForText: bestForText)
                print("data for others called treatmentDict is \(treatmentDict)")
                                self.name = treatment.name
                                self.about = treatment.about
                self.treatments.append(treatment)
                //                print("users array is \(self.users)")
                performUIUpdatesOnMain {
                    //self.textView.reloadData()
                    self.nameLabel.text = self.name!
                    self.textView.text = self.about!
                    print("data for others called name = \(self.name)")
                    self.selectButton.setTitle("Select \(self.name!)", for: UIControlState.normal)
                }
            }
            //self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
        //getData()
        
        if selectedIndex == 0 {
            getDataForInfusion()
            print("data for infusion called")
        } else {
            
            getData()
        }
        
        if name == "Intravenous Immunoglobulin (IVIG)" {
            name = "IVIG"
        } else if name == "CINQAIR® (Reslizumab)" {
            name = "CINQAIR®"
        }
        
        print("data for others called name = \(self.name)")
        print("data for others selectedIndex = \(self.selectedIndex)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
