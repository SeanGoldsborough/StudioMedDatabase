//
//  MapPin.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 6/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class MapPin: NSObject, MKAnnotation {
    let title: String?
    let addressName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, addressName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.addressName = addressName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return addressName
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
//    let detailLabel = UILabel()
//    detailLabel.numberOfLines = 0
//    detailLabel.font = detailLabel.font.withSize(12)
//    detailLabel.text = artwork.subtitle
//    detailCalloutAccessoryView = detailLabel
    
}
