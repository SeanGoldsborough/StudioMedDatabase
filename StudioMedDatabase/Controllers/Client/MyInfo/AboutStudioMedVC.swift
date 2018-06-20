//
//  AboutStudioMedVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 6/3/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

class AboutStudioMedVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        navigationController?.navigationBar.isHidden = false

        let initialLocation = CLLocation(latitude: 40.761952, longitude: -73.968933)
        centerMapOnLocation(location: initialLocation)
    
        let mapPin = MapPin(title: "StudioMed \n 133 E 58th St Ste 512, New York NY 10022", addressName: "Tap For Directions", coordinate: CLLocationCoordinate2D(latitude: 40.761952, longitude: -73.968933))
        mapView.addAnnotation(mapPin)
    }

    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension AboutStudioMedVC: MKMapViewDelegate {
  
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
        guard let annotation = annotation as? MapPin else { return nil }
    
        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {

            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapPin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
