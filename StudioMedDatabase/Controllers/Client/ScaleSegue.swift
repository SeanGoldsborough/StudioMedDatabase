//
//  ScaleSegue.swift
//  CustomViewControllerSegues
//
//  Created by Sean Goldsborough on 6/16/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import UIKit

class ScaleSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale ()  {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 1.00, y: 0.01)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: {
            success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
    
}


class UnwindSegue: UIStoryboardSegue {
    
    override func perform() {
        unwind()
    }
    
    func unwind ()  {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: 1.00, y: 0.001)
        }, completion: {
            success in
            fromViewController.dismiss(animated: false, completion: nil)
        })
    }
    
}


class SocialMediaSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale ()  {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: {
            success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        })
    }
    
}

class UnwindSocialMediaSegue: UIStoryboardSegue {
    
    override func perform() {
        unwind()
    }
    
    func unwind ()  {
        let toViewController = self.destination
        let fromViewController = self.source
        
        fromViewController.view.superview?.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: 1.00, y: 0.001)
        }, completion: {
            success in
            fromViewController.dismiss(animated: false, completion: nil)
        })
    }
    
}
