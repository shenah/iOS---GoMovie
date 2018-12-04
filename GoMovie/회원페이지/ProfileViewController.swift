//
//  ProfileViewController.swift
//  GoMovie
//
//  Created by 503-03 on 03/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //
    var profileImage = UIImageView()
    var tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserDefaults.standard.string(forKey: "id")
        
    }
    

}
