//
//  UIViewController+Extension.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/27/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController  {
    
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        let spinner = SpinnerView.showLoader(view: view)
        spinner.startAnimating()
        Client.logout(spinner: spinner,completionHandler: {[weak self]  (success,error,spinner)
            in
            spinner.stopAnimating()
            if success{
                self?.dismiss(animated: true, completion: nil)
            }
            else {
                AlertController.showAlert("Logout Failed", message: error?.localizedDescription ?? "Check your network connection")
            }
        })
        
    }
    
    @IBAction func addStudentTapped(_ sender: UIBarButtonItem) {
        let spinner = SpinnerView.showLoader(view: view)
        spinner.startAnimating()
        Client.getStudentInformation(completion: handleUserLocation(success: error:spinner_:), spinner: spinner)
        
    }
    
    func handleUserLocation(success: Bool, error : Error?, spinner_: UIActivityIndicatorView){
        spinner_.stopAnimating()
        if success {
            if  Client.Account.latitude != 0 &&  Client.Account.longitude != 0 {
                showUpdateLocationAlert(message: "You have already posted a student location. Would you like to overwrite your location.")
            }
            else {
                showAddLocationController(false)
            }
        }
        else {
            AlertController.showAlert("Can't add location", message: error?.localizedDescription ?? "Check your network connection")
        }
    }
    
    func showUpdateLocationAlert(message: String) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {
            ( UIAlertAction )
            in
            self.showAddLocationController(true)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alertVC,animated: true, completion: nil)
        
    }
    
    func showAddLocationController(_ updateLocation: Bool){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "addLocation") as! AddLocationViewController
        resultVC.updateLocation = updateLocation
        let navController = UINavigationController(rootViewController: resultVC)
        self.present(navController, animated:true, completion: nil)
    }
    
}

