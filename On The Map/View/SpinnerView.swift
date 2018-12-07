//
//  SpinnerVIew.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 12/4/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import Foundation
import UIKit
class SpinnerView {
    class func  showLoader(view: UIView) -> UIActivityIndicatorView {
        
        //Customize as per your need
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height:view.bounds.height))
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        spinner.layer.cornerRadius = 3.0
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        spinner.center = view.center
        view.addSubview(spinner)
        
        
        
        return spinner
    }
    
}
