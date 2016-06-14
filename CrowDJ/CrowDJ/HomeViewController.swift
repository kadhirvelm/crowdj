//
//  HomeViewController.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/11/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    
    let coreData = crowdjCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let temp_user = coreData.retrieveData("User")
        let user = temp_user!.last as? User
        name.text = "\(user!.userName!)"
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    @IBAction func Logout(sender: UIButton) {
        coreData.deleteAllData("User")
        performSegueWithIdentifier("Logout", sender: self)
    }
    
}
