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
    @IBOutlet weak var profileimg: UIImageView!
    var tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserDefaults.standard.string(forKey: "nickname")
        profileimg.layer.cornerRadius = (profileimg.frame.width/2)
        profileimg.layer.borderWidth = 0
        profileimg.layer.masksToBounds = true
        
    }
    //앱이 실행하는 중 로그아웃을 할 수 있기에 
    override func viewWillAppear(_ animated: Bool) {
        //프로필 사진 이름 가져오기
        let image = UserDefaults.standard.string(forKey: "profilePhoto")!
        if image == "null" {
            profileimg.image = UIImage(named: "account.jpg")
        }else{
            let url = URL(string: "http://192.168.0.113:8080/MobileServer/memberimage/\(image)")
            let imageData = try! Data(contentsOf: url!)
            profileimg.image = UIImage(data: imageData)
        }
    }
    

}
