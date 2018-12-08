//
//  LoginViewController.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/26/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK : Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subscribeToKeyboardNotifications()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        loginTapped()
    }
    func loginTapped(){
        setLoggingIn(true)
        Client.getSession(userName: self.emailTextField.text ?? "",password: self.passwordTextField.text ?? "",completion: self.handleSessionResponse(success : error:))
        
    }
    func handleSessionResponse(success: Bool, error: Error?){
        
        if success {
            
            Client.getUserData(completion: {[weak self] (response,error)
                in
                self?.setLoggingIn(false)
                if response {
                    self?.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
                else {
                    AlertController.showAlert("Login Failed",message:  error?.localizedDescription ?? "Unable to get user info")
                }
            })
            
        }
        else{
            setLoggingIn(false)
            AlertController.showAlert("Login Failed",message:  error?.localizedDescription ?? "Email or password is wrong")
        }
    }
    func  setLoggingIn(_ loggingIn: Bool){
        if loggingIn {
            activityIndicator.startAnimating()
        }
        else{
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        
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
            passwordTextField.becomeFirstResponder()
            return true
        }
        else if textField.returnKeyType==UIReturnKeyType.go
        {
            loginTapped()
            return true
        }
        return false
    }
    
    
    
    
}

