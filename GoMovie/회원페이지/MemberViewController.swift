//
//  MemberViewController.swift
//  GoMovie
//
//  Created by 503-03 on 30/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class MemberViewController: UIViewController {

    //AppDelegate 객체에 대한 참조 변수
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //로그인 정보 설정
        //print(appDelegate.id + appDelegate.nickname)
        if self.appDelegate.id != nil {
            self.tabBarController?.title = appDelegate.nickname + "님 "
            let image = appDelegate.image
            let url = URL(string: "http://192.168.0.113:8080/MobileServer/images/\(image)")
            
            //request.responseJSON(completionHandler:)
        }else{
            self.title = "로그인"
        }
        
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
