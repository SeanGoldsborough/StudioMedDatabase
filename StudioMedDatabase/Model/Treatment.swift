//
//  Treatment.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/11/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation

class Treatment : NSObject {
    public var name: String?
    public var about: String?
    public var price: String?
    public var bestFor: String?
    
    init(nameText: String, aboutText: String, priceText: String, bestForText: String) {
        name = nameText
        about = aboutText
        price = priceText
        bestFor = bestForText
    }

}

class TreatmentData : NSObject {
    
    public var name: String?
    public var about: String?
    public var price: String?
    public var bestFor: String?
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> TreatmentData {
        struct Singleton {
            static var sharedInstance = TreatmentData()
        }
        return Singleton.sharedInstance
    }
    
}


class TreatmentArray : NSObject {
    public var listOfTreatments : [TreatmentData] = []
    
    static let sharedInstance = TreatmentArray()
}
