//
//  ProfileViewController.swift
//  GoMovie
//
//  Created by 503-03 on 03/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var backimg: UIImageView!
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //댓글 정보 저장할 객체 생성
    var list : [ReviewVO] = [ReviewVO]()
    //댓글 개수 저장
    var count : Int?
    
    func getMyreviews(id : String){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //배경 이미지 설정
        backimg.image = UIImage(named: "fantasticbests.jpg")

        profileimg.layer.cornerRadius = (profileimg.frame.width/2)
        profileimg.layer.borderWidth = 0
        profileimg.layer.masksToBounds = true
        
        
        
    }
    //앱이 실행하는 중 로그아웃을 할 수 있기에 
    override func viewWillAppear(_ animated: Bool) {
        //프로필 사진 이름 가져오기
        if UserDefaults.standard.string(forKey: "profilePhoto") != "null"{
            let image = UserDefaults.standard.string(forKey: "profilePhoto")
            let url = URL(string: "http://192.168.0.113:8080/MobileServer/memberimage/\(image)")
            let imageData = try! Data(contentsOf: url!)
            profileimg.image = UIImage(data: imageData)
        }else{
            profileimg.image = UIImage(named: "account.jpg")
        }
        if let id = UserDefaults.standard.string(forKey: "id"){
            getMyreviews(id : id)
        }
        
        
    }
    
}
extension ProfileViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "아이디"
            
        case 1:
            cell?.textLabel?.text = "내 댓글"
            cell?.accessoryType = .disclosureIndicator
        default:
            ()
        }
    }

}
