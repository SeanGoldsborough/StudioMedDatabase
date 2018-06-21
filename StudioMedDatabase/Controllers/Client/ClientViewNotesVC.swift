//
//  ClientViewNotesVC.swift
//  StudioMedDatabase
//
//  AdminViewNotes.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/30/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ClientViewNotesVC: UIViewController, UITextViewDelegate {
    
    var appointment = AppointmentData.sharedInstance
    
    var keyboardIsShown = false
    
    var delegate:GetDataProtocol?
    
    @IBOutlet weak var notesTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        notesTextView.text = appointment.notes ?? "No Notes Written"
        notesTextView.textColor = UIColor.white

        if notesTextView.text == "Add A Note For The Doctor" {
            notesTextView.text = "No Notes"
        }

        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(doneButtonAction))
        doneBtn.tintColor = UIColor.black
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.notesTextView.inputAccessoryView = toolbar       
        
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
}

