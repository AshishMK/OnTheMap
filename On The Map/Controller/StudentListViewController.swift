//
//  StudentListViewController.swift
//  On The Map
//
//  Created by Ashish Nautiyal on 11/26/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class StudentListViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationsData.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentableViewCell")!
        let studentLocation = StudentLocationsData.locations[indexPath.row]
        cell.textLabel?.text = studentLocation.firstName + " " + studentLocation.lastName
        cell.detailTextLabel?.text = studentLocation.mediaURL
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func handleStudentLocationResponse(){
        self.tableView.reloadData()
    }
   
    
}
