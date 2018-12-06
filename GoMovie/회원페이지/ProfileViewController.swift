//
//  ProfileViewController.swift
//  GoMovie
//
//  Created by 503-03 on 03/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class ProfileViewController: UIViewController {

    
    @IBOutlet weak var backimg: UIImageView!
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var lblnickname: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //로그인 정보 가져오기
    var id = UserDefaults.standard.string(forKey: "id")
    var nickname = UserDefaults.standard.string(forKey: "nickname")
    var profilePhono = UserDefaults.standard.string(forKey: "profilePhoto")
    
    //댓글 정보 저장할 객체 생성
    var list : [ReviewVO] = [ReviewVO]()
    
    //댓글 개수 저장
    var count : Int = 0
    
    func getMyreviews(id : String){
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/reviews/myreviews", method: .get, parameters: ["id" : id], encoding: URLEncoding.default, headers: nil)
        request.responseJSON(completionHandler: {(response) in
            print(response)
            switch response.result{
            case.success:
                let dic = response.result.value as! NSDictionary
                self.count = dic["count"] as! Int
                let reviews = dic["reviews"] as! NSArray
                for re in reviews{
                    let review = re as! NSDictionary
                    let reviewVO : ReviewVO  = ReviewVO()
                    reviewVO.content = review["content"] as? String
                    reviewVO.dispdate = review["dispdate"] as? String
                    reviewVO.likecnt = review["likecnt"] as? Int
                    reviewVO.rno = review["rno"] as? Int
                    reviewVO.movieTitle = review["movieTitle"] as? String
                    self.list.append(reviewVO)
                    self.tableView.reloadData()
                }
                break
            case.failure(let error):
                print("댓글 요청실패:\(error)")
                break
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //배경 이미지 설정
        backimg.image = UIImage(named: "fantasticbests.jpg")

        profileimg.layer.cornerRadius = (profileimg.frame.width/2)
        profileimg.layer.borderWidth = 0
        profileimg.layer.masksToBounds = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    //앱이 실행하는 중 로그아웃을 할 수 있기에 
    override func viewWillAppear(_ animated: Bool) {
        //프로필 사진 이름 가져오기
        if profilePhono != "null", profilePhono != nil{
            let url = URL(string: "http://192.168.0.113:8080/MobileServer/memberimage/\(profilePhono!)")
            let imageData = try! Data(contentsOf: url!)
            profileimg.image = UIImage(data: imageData)
        }else{
            profileimg.image = UIImage(named: "account.jpg")
        }
        if id != nil{
            getMyreviews(id : id!)
            lblnickname.text = nickname!
            lblnickname.sizeToFit()
        }
        self.tableView.sizeToFit()
       
    }
    
}
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "아이디"
            if id != nil{
                cell.detailTextLabel?.text = id!
            }else{
                cell.detailTextLabel?.text = "로그인"
            }
           break
        case 1:
            cell.textLabel?.text = "내 댓글"
            cell.detailTextLabel?.text = "\(count)"
            break
        default:
            ()
        }
        return cell
    }
    //셀을 선택했을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if id != nil{
                let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default){
                    (action) in
                    UserDefaults.standard.set(nil, forKey: "id")
                    UserDefaults.standard.set("닉네임", forKey: "nickname")
                    UserDefaults.standard.set("null", forKey: "profilePhoto")
                    self.id = nil
                    self.nickname = "닉네임"
                    self.profilePhono = "null"
                    tableView.reloadData()
                    self.viewWillAppear(true)
                })
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                self.present(alert, animated: true)
            }else{
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true)
                
            }
            break
        case 1:
            if count != 0{
                let myReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyReviewViewController") as! MyReviewViewController
                myReviewViewController.list = list
                self.navigationController?.pushViewController(myReviewViewController, animated: true)
            }else{
                //알림
                let alert = UIAlertController(title: "댓글 없음!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
            break
        default:
            ()
        }
    }

}
