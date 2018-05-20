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
        
        //TODO: Add animation & push to nav from WILDZAHR/MusicPlayer App to LogIn and SignUp buttons
        
        
        @IBAction func loginButton(_ sender: Any) {
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            navigationController?.pushViewController(loginVC, animated: true)
        }
        
        
        @IBAction func signupButton(_ sender: Any) {
            
            //        let signupVC = storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
            //        navigationController?.pushViewController(signupVC, animated: true)
        }
        
        //    var pageControl = UIPageControl()
        //    func configurePageControl() {
        //        // The total number of pages that are available is based on how many available colors we have.
        //        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 130,width: UIScreen.main.bounds.width,height: 50))
        //        //self.pageControl.numberOfPages = pages.count
        //        self.pageControl.currentPage = 0
        //        self.pageControl.tintColor = UIColor.black
        //        self.pageControl.pageIndicatorTintColor = UIColor.white
        //        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        //        self.view.addSubview(pageControl)
        //    }
        //
        //    fileprivate lazy var pages: [UIViewController] = {
        //        return [
        //            self.getViewController(withIdentifier: "Page1"),
        //            self.getViewController(withIdentifier: "Page2")
        //        ]
        //    }()
        //
        //    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        //        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        //    }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            navigationController?.navigationBar.isHidden = true
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isPagingEnabled = true
            
            //configurePageControl()
            
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    extension OnBoardingVC : UICollectionViewDataSource {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of items
            //return store.audiobooks.count
            //configurePageControl()
            pageControl.numberOfPages = images.count
            
            
            return images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OnBoardingCollectionViewCell
            cell.backgroundColor = UIColor.blue
            
            cell.cellImage.image = images[indexPath.row]
            cell.text.text = text[indexPath.row]
            cell.subText.text = subText[indexPath.row]
            
            //let animation = collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
            //pageTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: <#T##(Timer) -> Void#>)
            
            // TODO: Fix timer so that it runs smoothly
            //        pageTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { (pageTimer) in
            //            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
            //        })
            
            
            
            //Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
            //        Float(UICollectionViewScrollPosition.CenteredHorizontally.rawValue) / Float(UICollectionViewScrollPosition.CenteredVertically.rawValue)
            //
            
            //        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
            //
            //        cell.imageView.image = flickrPhoto.thumbnail
            
            //        let books = store.audiobooks[indexPath.row]
            //        cell.displayContent(image: store.images[indexPath.row])
            
            
            return cell
        }
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
            
            //let collDetailVC = storyboard?.instantiateViewController(withIdentifier: "CollDetailVC") as! CollectionViewDetailVC
            
            //let collDetailVC.albumImage = cell.displayContent(image: store.images[indexPath.row])
            
            //navigationController?.pushViewController(collDetailVC, animated: true)
            //        self.bottomButton.titleLabel?.text = "Remove Selected Pictures"
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
        
        
        /*
         // Uncomment this method to specify if the specified item should be selected
         override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
         override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
         
         }
         */
    }
    
    extension OnBoardingVC: UICollectionViewDelegateFlowLayout {
        
        // Sets the size of collection view cells
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            //2
            
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            //let availableWidth = view.frame.width - paddingSpace
            //        let availableWidth = collectionView.frame.width
            //        let availableHeight = collectionView.frame.height
            //        let widthPerItem = availableWidth
            //        let heightPerItem = availableHeight
            //let widthPerItem = availableWidth / itemsPerRow
            
            
            
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

// MARK: - Private
//private extension CollectionViewController {
//    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
//        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as IndexPath).row]
//    }
//}

//extension FlickrPhotosViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        // 1
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        textField.addSubview(activityIndicator)
//        activityIndicator.frame = textField.bounds
//        activityIndicator.startAnimating()
//
//        flickr.searchFlickrForTerm(textField.text!) {
//            results, error in
//
//
//            activityIndicator.removeFromSuperview()
//
//
//            if let error = error {
//                // 2
//                print("Error searching : \(error)")
//                return
//            }
//
//            if let results = results {
//                // 3
//                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
//                self.searches.insert(results, at: 0)
//
//                // 4
//                self.collectionView?.reloadData()
//            }
//        }
//
//        textField.text = nil
//        textField.resignFirstResponder()
//        return true
//    }
//}

