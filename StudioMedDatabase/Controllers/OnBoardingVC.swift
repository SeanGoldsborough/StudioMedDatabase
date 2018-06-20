//
//  OnBoardingVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/17/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import Firebase

    fileprivate let itemsPerRow: CGFloat = 3
    
    //fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    var collCell = OnBoardingCollectionViewCell()
    
    var images = [#imageLiteral(resourceName: "housecall1"), #imageLiteral(resourceName: "Pediatric-Nurse-Practitioner"), #imageLiteral(resourceName: "doctor-office-phone"), #imageLiteral(resourceName: "pic4")]
    
    var text = ["At Home", "In-Office", "Telemedicine", "Sign Up Today!"]
    
    var subText = ["Schedule a house call from a local doctor 24/7", "Visit us at our Manhattan Office", "Out of town? Need a prescription refilled? Call us!", "Join today and get access to 24/7 medical treatment!"]
    
    var pageTimer: Timer!
    
class  OnBoardingVC: UIViewController {
        
        @IBOutlet weak var pageControl: UIPageControl!
        
        @IBOutlet weak var collectionView: UICollectionView!
        private let reuseIdentifier = "CollectionItem"

        @IBAction func loginButton(_ sender: Any) {
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
        @IBAction func signupButton(_ sender: Any) {

        }

        override func viewDidLoad() {
            super.viewDidLoad()
            
            navigationController?.navigationBar.isHidden = true
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isPagingEnabled = true
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            
        }
    }

    
    extension OnBoardingVC : UICollectionViewDataSource {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
            pageControl.numberOfPages = images.count
            return images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OnBoardingCollectionViewCell
            cell.backgroundColor = UIColor.blue
            
            cell.cellImage.image = images[indexPath.row]
            cell.text.text = text[indexPath.row]
            cell.subText.text = subText[indexPath.row]

            return cell
        }
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {

        }
    }
    
    extension OnBoardingVC: UICollectionViewDelegate {
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
            pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
        
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
        
        // Uncomment this method to specify if the specified item should be highlighted during tracking
        func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
    
    extension OnBoardingVC: UICollectionViewDelegateFlowLayout {
        
        // Sets the size of collection view cells
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            //2
            
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
        //3
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }
        
        // 4
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
        }
}

