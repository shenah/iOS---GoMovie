//
//  RegisterViewController.swift
//  GoMovie
//
//  Created by 503-03 on 29/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController {


    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var pwConTF: UITextField!
    @IBOutlet weak var regbtn: UIButton!
    @IBOutlet weak var cancelbtn: UIButton!
    
    //선택한 이미지 파일의 URL과 이름을 저장하는 변수
    var imageURL : URL!
    
    @IBAction func pickImg(_ sender: Any) {
        //대화상자 생성
        let select = UIAlertController(title:"이미지를 가져올 곳을 선택하세요!", message:nil, preferredStyle:.actionSheet)
        select.addAction(UIAlertAction(title:"카메라", style:.default){
            (_) in self.presentPicker(source:.camera)
        })
        select.addAction(UIAlertAction(title:"앨범", style:.default){
            (_) in self.presentPicker(source:.savedPhotosAlbum)
        })
        select.addAction(UIAlertAction(title:"사진 라이브러리", style:.default){
            (_) in self.presentPicker(source:.photoLibrary)
        })
        select.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(select, animated:true)

    }
    
    @IBAction func signUp(_ sender: Any) {
        //파라이터 가져오기
        let id = idTF.text!
        let nickname = nicknameTF.text!
        let pw = pwTF.text!
        let pwCon = pwConTF.text!

        guard id.count != 0 else{
            return
        }
        
        let parameters = ["id" : id,
                          "nickname" : nickname,
                          "pw" : pw]
        
        Alamofire.upload(multipartFormData: {multipartFormData in
            multipartFormData.append(self.imageURL, withName: "image")
            for p in parameters{
                multipartFormData.append((p.value.data(using: String.Encoding.utf8))!, withName: p.key)
            }
        }, to: "http://192.168.0.113:8080/MobileServer/member/register", method: .post, encodingCompletion: {encodingResult in
            switch encodingResult {
        case .success(let upload, _, _):
            upload.response(completionHandler: { (response) in
                print(response.data!)
            })
            
        case .failure(let encodingError):
            print("error:\(encodingError)")
            }
        })

    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func presentPicker(source: UIImagePickerController.SourceType){
        //유효한 소스타입이 아니면 중단
        guard UIImagePickerController.isSourceTypeAvailable(source) == true else{
            let alert = UIAlertController(title:"사용할 수 없는 타입입니다.", message:nil, preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated:false)
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        
        self.present(picker, animated:true )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePhoto.image = UIImage(named: "account.jpg")
        //네모난 이미지 뷰를 등글게 만들기
        profilePhoto.layer.cornerRadius = (profilePhoto.frame.width/2)
        profilePhoto.layer.borderWidth = 0
        profilePhoto.layer.masksToBounds = true

        idTF.placeholder = "아이디"
        nicknameTF.placeholder = "닉넴"
        pwTF.placeholder = "비밀번호"
        pwConTF.placeholder = "비밀번호 확인"
        regbtn.layer.cornerRadius = 5
        cancelbtn.layer.cornerRadius = 5
        
        
    }
    

}
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //이미지 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.profilePhoto.image =
            info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        print(imageURL)
        picker.dismiss(animated:false)
    }

}
