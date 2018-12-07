//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 12/4/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var websiteText: UITextField!
    @IBOutlet weak var locationNameText: UITextField!
    
    var updateLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subscribeToKeyboardNotifications()
        websiteText.delegate = self
        locationNameText.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func findLocation(_ sender: Any) {
        findLocation()
    }
    
    func findLocation(){
        if locationNameText.text == "" {
            AlertController.showAlert("Location Not Found",message: "Must enter location")
        }
        else if websiteText.text == "" {
            AlertController.showAlert("Location Not Found",message: "Must enter website")
        }
        else if !canOpenURL(string: websiteText.text){
            AlertController.showAlert("Location Not Found",message: "Enter a valid website url")
        }
        else{
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "findLocation") as! FindLocationViewController
            controller.address = locationNameText?.text ?? ""
            controller.mediaURL = websiteText?.text ?? ""
            controller.updateLocation = updateLocation
            //  self.present(controller, animated: true, completion: nil)
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    //MARK: Keyboard height detction methods
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = getKeyboardHeight(notification) * -1
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        return 30
        
    }
    
    // MARK: Text Field Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType==UIReturnKeyType.next
        {
            websiteText.becomeFirstResponder()
            return true
        }
        else if textField.returnKeyType==UIReturnKeyType.go
        {
           findLocation()
            return true
        }
        return false
    }
    
}
