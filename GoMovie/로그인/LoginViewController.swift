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
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func login(_ sender: Any) {
        guard idtxt.text != nil, pwtxt.text != nil else{
            self.label.text = "아이디와 비밀번호를 입력하세요!"
            return
        }
        
        //입력한 내용 가져오기
        let id = idtxt.text
        let pw = pwtxt.text
        
        //id pw 확인
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/member/login", method:.post, parameters:["id" : id!, "pw" : pw!])
        //결과
        request.responseJSON{
            response in
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
        idtxt.placeholder = "아이디"
        pwtxt.placeholder = "비밀번호"
        btnlogin.layer.cornerRadius = 5
        btnreg.layer.cornerRadius = 5
        idtxt.becomeFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        idtxt.resignFirstResponder()
        pwtxt.resignFirstResponder()
    }
    

}
