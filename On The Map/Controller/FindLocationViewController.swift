//
//  FindLocationViewController.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 12/4/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FindLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var address: String = ""
    var mediaURL: String = ""
    var lat: Double = 0
    var lon: Double = 0
    var updateLocation = false
    var   spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner = SpinnerView.showLoader(view: view)
        getLocation()
    }
    
    
    @IBAction func submitLocation(_ sender: Any) {
        print("hsvc \(updateLocation)")
        spinner?.startAnimating()
        if updateLocation {
            Client.putUserLocation(mapString: address, mediaURL: mediaURL, latitude: lat, longitude: lon, completion: { [weak self]
                (success,error)
                in
                self?.spinner?.stopAnimating()
                if success
                {
                    StudentLocationsData.locations = [StudentLocation]()
                    self?.dismiss(animated: true,  completion: nil)
                }
                else{
                    AlertController.showAlert("Can not update location",message: error.debugDescription )
                }
            })
        }
        else{
            Client.postUserLocation(mapString: address, mediaURL: mediaURL, latitude: lat, longitude: lon, completion: { [weak self]
                (success,error)
                in
                self?.spinner?.stopAnimating()
                if success
                {
                    StudentLocationsData.locations = [StudentLocation]()
                    self?.dismiss(animated: true,  completion: nil)
                }
                else{
                    AlertController.showAlert("Can not post location",message: error.debugDescription )
                }
            })
        }
    }
    
    
    func getLocation(){
        
        spinner?.startAnimating()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            self?.spinner?.stopAnimating()
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    AlertController.showAlert("Location not found",message:  "Go back and enter a valid location"){
                        (action)
                        in
                        self?.navigationController!.popViewController(animated: false)
                    }
                    return
            }
            self?.lat = location.coordinate.latitude
            self?.lon = location.coordinate.longitude
            // This is a version of the Double type.
            let coordinate = CLLocationCoordinate2D(latitude: (self?.lat)!, longitude: (self?.lon)!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(self?.address ?? "")"
            annotation.subtitle = "\(self?.mediaURL ?? "")"
            self?.mapView.addAnnotation(annotation)
            // Use your location
        }
    }
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
        }
    }
    
    
    
}




