//
//  ViewController.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/27/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var   spinner: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner  = SpinnerView.showLoader(view: view)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if StudentLocationsData.locations.count == 0  {
           spinner?.startAnimating()
            Client.getStudentLocations(completion: self.getResponseHandler(locations: error :))
        }
    }
    
    func getResponseHandler(locations: [StudentLocation],error: Error?){
        //Hide
            spinner?.stopAnimating()
         StudentLocationsData.locations = locations
        if let topController = UIApplication.topViewController() {
            
                if topController is StudentListViewController {
                    return (topController as! StudentListViewController).handleStudentLocationResponse()
                }
                else if topController is MapViewController {
                    return (topController as! MapViewController).handleStudentLocationResponse()
                }
            
        }
        if let error = error {
              AlertController.showAlert("Can't find locations", message: error.localizedDescription )
        }
    }
   
    
}



