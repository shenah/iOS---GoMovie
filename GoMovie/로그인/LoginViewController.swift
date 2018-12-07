//
//  LoginViewController.swift
//  GoMovie
//
//  Created by 503-03 on 06/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
//Alamofire는 URL 통신을 쉽게 할 수 있도록 해주는 외부 라이브러리 ﻿
import Alamofire
class LoginViewController: UIViewController {

    @IBOutlet weak var idtxt: UITextField!
    @IBOutlet weak var pwtxt: UITextField!
    
    @IBOutlet weak var btnlogin: UIButton!
    @IBOutlet weak var btnreg: UIButton!
    @IBOutlet weak var btnskip: UIButton!
    
    @IBOutlet weak var label: UILabel!
    //AppDelegate 객체에 대한 참조 변수
    var appDelegate : AppDelegate!
    
    //로그인 화면의 X를 눌렀을 때
    @IBAction func skip(_ sender: Any) {
        //비동기적으로 이동
        DispatchQueue.main.async {
            let movieListVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabbarController") as! UITabBarController
            tabBarController.setViewControllers([movieListVC, profileViewController], animated: false)
            let navigationController = UINavigationController.init(rootViewController: tabBarController)
            
            self.present(navigationController, animated: true)
        }
        
    }
    @IBAction func login(_ sender: Any) {
        guard idtxt.text != nil, pwtxt.text != nil else{
            self.label.text = "아이디와 비밀번호를 입력하세요!"
            return
        }
        
        let id = idtxt.text
        let pw = pwtxt.text
        
        //id pw 확인
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/member/login?id=\(id!)&pw=\(pw!)", method:.get, parameters:nil)
        //결과
        request.responseJSON{
            response in
            print(response)
            switch response.result{
            case .success:
                let jsonObject = response.result.value as! [String:Any]
                print(jsonObject)
                let result = jsonObject["member"] as! NSDictionary
                
                let id = (result["id"] as! NSString) as String
                if id == "NULL"{
                    self.label.text = "아이디 혹은 비밀번호가 틀렸습니다."
                    self.label.textColor = UIColor.red
                    self.label.textAlignment = .center
                }else{
                    //자동로그인 정보 저장 - UserDefaults 파일
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(id, forKey: "id")
                    let nickname = (result["nickname"] as! NSString) as String
                    userDefaults.set(nickname, forKey: "nickname")
                    let image =
                        (result["image"] as! NSString) as String
                    userDefaults.set(image, forKey: "profilePhoto")
                    //페이지 이동
                    self.skip(self.btnskip)
                }
            case .failure(let error):
                print("로그인 실패:\(error)")
                
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(registerViewController, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //화면 생성시 로그인 확인
        if UserDefaults.standard.string(forKey: "id") != nil {
            self.skip(btnskip)
        }else{
        idtxt.placeholder = "아이디"
        pwtxt.placeholder = "비밀번호"
        btnlogin.layer.cornerRadius = 5
        btnreg.layer.cornerRadius = 5
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
