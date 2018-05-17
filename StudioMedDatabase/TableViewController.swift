//
//  TableViewController.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/8/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
     @IBOutlet weak var tableView: UITableView!
    
    var dummyData  = ["10/10/10 - 01:00 PM - Infusion", "10/10/10 - 01:00 PM - Infusion", "10/10/10 - 01:00 PM - Infusion"]
    
    var sections = ["pizza", "deep dish pizza", "calzone"]
    
    var items = [["Margarita", "BBQ Chicken", "Pepperoni"], ["sausage", "meat lovers", "veggie lovers"], ["sausage", "chicken pesto", "prawns", "mushrooms"]]


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sections[section])"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    static let cellReuseIdentifier = "identifier"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "You Clicked on a Row!", message: indexPath.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
        // Override to support conditional editing of the table view.
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return false
        }

        // Override to support editing the table view.
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                //sections.removeAtIndex(indexPath.row)
                items.remove(at: indexPath.row)

                
                tableView.deleteRows(at: [indexPath], with: .automatic)
    
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
    
    
//        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//        {
////            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 90))
////            if (section == 1) {
////                headerView.backgroundColor = UIColor.red
////            } else {
////                headerView.backgroundColor = UIColor.lightGray
////            }
//
//            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeader.reuseIdentifer) as? CustomHeader else {
//                return nil
//            }
//            header.backgroundColor = UIColor.red
//
//            header.customLabel.text = "Section \(section + 1)"
//
//            return header
//        }
    
}
