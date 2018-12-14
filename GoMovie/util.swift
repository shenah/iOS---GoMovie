//
//  Util.swift
//  GoMovie
//
//  Created by 503-03 on 07/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class Util: NSObject {
    
    // 로그인 알림
    func loginAlert(controller : UIViewController, message : String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "로그인", style: .default, handler: {(action) in
            //로그인 뷰 컨트롤러 가져오기
            let loginViewController = controller.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            controller.present(loginViewController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "나중에", style: .cancel))
        controller.present(alert, animated: true)
    }
    //일반 알림
    func alert(controller : UIViewController, message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        controller.present(alert, animated: true)
    }
    
//    //alamofire
//    func useAlamofire(serverURL: String, parameters:[NSDictionary], httpmethod: HTTPMethod) -> NSDictionary{
//        var temp = httpmethod
//        let url = "http://192.168.0.113:8080/MobileServer/" + serverURL
//        let request = Alamofire.request(url, method: temp, parameters: parameters, encoding: URLEncoding.default, headers: nil)
//        //결과
//        request.responseJSON{
//            response in
//            switch response.result{
//            case .success:
//                let jsonObject = response.result.value as! [NSDictionary]
//                return jsonObject
//            case .failure(let error):
//                return ["error" : "\(error)" ]
//
//            }
//        }
//    }
    
}
