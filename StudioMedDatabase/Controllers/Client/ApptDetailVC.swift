//
//  ApptDetailVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ApptDetailVC: UIViewController {
    var coloredCellIndex = Int()

    @IBAction func cancelApptButton(_ sender: Any) {
        print("cancel appt button pressed")
        
        //AlertView.alertPopUpTwo(view: self, title: "Appointment has been canceled!", alertMessage: "", buttonTitle: "OK")
        AlertView.apptAlert(view: self, alertTitle: "Appointment has been canceled!", alertMessage: "")
        
        var mainViewController:ClientAppointmentHistoryVC?

        var zipBool = "0"
        
        mainViewController?.coloredCellIndex = self.coloredCellIndex
        print("colored index is \(self.coloredCellIndex)")
        print("colored index is \(mainViewController?.coloredCellIndex)")
        mainViewController?.selectedIndexes.append(self.coloredCellIndex)
        //mainViewController?.users[coloredCellIndex].phoneNumber = zipBool
        //mainViewController?.tableView.reloadData()
        //clientApptHistory.tableView.reloadData()
        
        //navigationController?.popViewController(animated: true)
        //navigationController?.pushViewController(clientApptHistory, animated: true)
        
        
    }
    
    
    @IBAction func confirmAppt(_ sender: Any) {
        //AlertView.alertPopUpTwo(view: self, title: "Appointment has been created!", alertMessage: "A member of the StudioMed staff will be in contact shortly to confirm.", buttonTitle: "OK")
        
        AlertView.apptAlert(view: self, alertTitle: "Appointment has been created!", alertMessage: "A member of the StudioMed staff will be in contact shortly to confirm.")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("colored index is \(coloredCellIndex)")
        navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
