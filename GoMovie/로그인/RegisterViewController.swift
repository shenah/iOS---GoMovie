//
//  RegisterViewController.swift
//  GoMovie
//
//  Created by 503-03 on 29/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var pw: UITextField!
    @IBOutlet weak var pwConfrim: UITextField!
    @IBOutlet weak var regbtn: UIButton!
    @IBAction func register(_ sender: Any) {
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regbtn.layer.cornerRadius = 3
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
