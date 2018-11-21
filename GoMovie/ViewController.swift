//
//  ViewController.swift
//  GoMovie
//
//  Created by 503-03 on 21/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
//Alamofire는 URL 통신을 쉽게 할 수 있도록 해주는 외부 라이브러리 ﻿
import Alamofire

class ViewController: UIViewController {

    
 
    @IBOutlet weak var idtxt: UITextField!
    @IBOutlet weak var pwtxt: UITextField!
    
    @IBOutlet weak var btnlogin: UIButton!
   
    @IBOutlet weak var label: UILabel!
    //AppDelegate 객체에 대한 참조 변수
    var appDelegate : AppDelegate!
    
    @IBAction func skip(_ sender: Any) {
        let movieListTVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieListTableViewController") as! MovieListTableViewController
        self.present(movieListTVC, animated: true)
    }
    @IBAction func login(_ sender: Any) {
        if btnlogin.title(for: .normal) == "로그아웃"{
            appDelegate.id = nil
            appDelegate.nickname = nil
            appDelegate.image = nil
            btnlogin.setTitle("로그인", for: .normal)
        }else{
            let id = idtxt.text
            let pw = pwtxt.text
            
            //id pw 확인
            let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/member/login?id=\(id!)", method:.get, parameters:nil)
            //결과 사용
            request.responseJSON{
                response in
                print(response.result.value!)
                let jsonObject = response.result.value as! [String:Any]
                print(jsonObject)
                let result = jsonObject["member"] as! NSDictionary
                let id = result["id"] as! NSString
                if id == "NULL"{
                    self.label.text = "아이디 혹은 비밀번호가 틀렸습니다."
                }else{
                    self.appDelegate.id = id as String
                    self.appDelegate.nickname = (result["nickname"] as! NSString) as String
                    self.appDelegate.image =
                        (result["image"] as! NSString) as String
                    
                    let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "tabbarController") as! UITabBarController
                
                    let movieListTVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieListTableViewController") as! MovieListTableViewController
                    
                    tabbarController.setViewControllers([movieListTVC], animated: false)
                    
                    let navigationController = UINavigationController.init(rootViewController: tabbarController)
                    
                    self.present(navigationController, animated: true)
                }
                    
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        idtxt.placeholder = "아이디"
        pwtxt.placeholder = "비밀번호"
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //화면 생성시 로그인 확인
        if appDelegate.id == nil {
            btnlogin.setTitle("로그인", for: .normal)
            //self.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        }else{
            btnlogin.setTitle("로그아웃", for: .normal)
        }
    }


}

