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
    var price: String?
    var appointment = AppointmentData.sharedInstance
    var newAppointment = NewAppointmentData.sharedInstance
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var treatments = [Treatment]()
    var selectedIndex = Int()
    var treatmentCatName = ["ivTherapy", "urgentCare", "houseCalls"]
    
    var delegate:GetDataProtocol?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    //
    @IBAction func selectTreatmentButton(_ sender: Any) {
 
        print("the name label text is \(nameLabel.text)")
        newAppointment.treatment1 = nameLabel.text!
        var vcCount = 4
        if selectedIndex == 1 || selectedIndex == 2 {
            vcCount = 3
        }
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        navigationController!.popToViewController(viewControllers[viewControllers.count - vcCount], animated: true)
    }
    
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
                
                print("data for iv priceNumberText treatment detail vc is: \(priceNumberText)")
                
                
                let treatment = Treatment(nameText: treatmentNameText, aboutText: aboutText, priceText: priceNumberText, bestForText: bestForText)
                print("data for ivtreatmentDict is \(treatmentDict)")
                self.treatments.append(treatment)

                performUIUpdatesOnMain {
                    self.nameLabel.text = self.name!
                    self.textView.text = self.about!
                    self.priceLabel.text = treatment.price!
                    print("data for iv name = \(self.name)")
                    self.selectButton.setTitle("Select \(self.name!.uppercased())", for: UIControlState.normal)
                    
                }
            }
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
                performUIUpdatesOnMain {
                    self.nameLabel.text = self.name!
                    self.textView.text = self.about!
                    print("data for others called name = \(self.name)")
                    self.selectButton.setTitle("Select \(self.name!.uppercased())", for: UIControlState.normal)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if price == " " {
            performUIUpdatesOnMain {
                self.priceLabel.isHidden = true
            }
            
        }
        
        print("data for others called name = \(self.name)")
        print("data for others selectedIndex = \(self.selectedIndex)")
        
    }
   
}
