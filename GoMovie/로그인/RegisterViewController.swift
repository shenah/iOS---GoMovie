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
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var lblpw: UILabel!
    @IBOutlet weak var pwConTF: UITextField!
    @IBOutlet weak var lblpwCon: UILabel!
    @IBOutlet weak var regbtn: UIButton!
    @IBOutlet weak var cancelbtn: UIButton!
    
    //선택한 이미지 파일의 URL과 이름을 저장하는 변수
    var imageURL : URL!
    
    //프로필 사진 선택 버튼 이벤트
    @IBAction func pickImg(_ sender: Any) {
        //ImagePickerController의 소스타입을 선택하는 대화상자 생성
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
    //ImagePickerController 생성
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
    
    //회원가입 버튼 이벤트
    @IBAction func signUp(_ sender: Any) {

        guard idTF.text != nil, nicknameTF.text != nil, pwTF.text != nil, pwConTF.text != nil else{
            
            return
        }
        //파라이터 가져오기
        let id = idTF.text!
        let nickname = nicknameTF.text!
        let pw = pwTF.text!
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPaths[0]
        let filePath = docDir
        
        //파라미터 배열 생성
        let parameters = ["id" : id,
                          "nickname" : nickname,
                          "pw" : pw]
        //Alamofire의 multipartFormData로 회원가입 요청
        Alamofire.upload(multipartFormData: {multipartFormData in
            if let url = self.imageURL{
                multipartFormData.append(url, withName: "image")
            }
            for p in parameters{
                multipartFormData.append((p.value.data(using: String.Encoding.utf8))!, withName: p.key)
            }
        }, to: "http://192.168.0.113:8080/MobileServer/member/register", method: .post, encodingCompletion: {encodingResult in
        
            switch encodingResult {
        case .success(let uploadRequest, _, _):
            uploadRequest.responseJSON(completionHandler: { json in
                let dic = json.result.value as! NSDictionary
                if dic["register"] != nil{
                    //회원가입 성공한 후 로그인 화면으로 이동
                    let alert = UIAlertController(title: "회원가입 성공하셨습니다!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler:{(action) in
                        self.presentingViewController?.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true)
                }else{
                    print("회원가입 실패")
                }
                
            })
        case .failure(let error):
            print("회원가입 실패:\(error)")
            }
        })

    }
    
    //취소 버튼 이벤트
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //기본 이미지 설정
        profilePhoto.image = UIImage(named: "account.jpg")
        //네모난 이미지 뷰를 등글게 만들기
        profilePhoto.layer.cornerRadius = (profilePhoto.frame.width/2)
        profilePhoto.layer.borderWidth = 0
        profilePhoto.layer.masksToBounds = true

        idTF.placeholder = "아이디"
        nicknameTF.placeholder = "닉네임"
        pwTF.placeholder = "비밀번호(8자이상, 대, 소문자, 숫자 조합)"
        pwConTF.placeholder = "비밀번호 확인"
        regbtn.layer.cornerRadius = 5
        cancelbtn.layer.cornerRadius = 5
        idTF.becomeFirstResponder()
        
        idTF.delegate = self
        nicknameTF.delegate = self
        pwTF.delegate = self
        pwConTF.delegate = self
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        idTF.resignFirstResponder()
        nicknameTF.resignFirstResponder()
        pwTF.resignFirstResponder()
        pwConTF.resignFirstResponder()
    }
    

}
extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //이미지 선택했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.profilePhoto.image =
            info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let docDir = dirPaths[0]
//        let filePath = docDir + "/profile.png"
//        let fileMgr = FileManager.default
//        let imgdata = profilePhoto.image?.pngData()
//        fileMgr.createFile(atPath: filePath, contents: imgdata, attributes: nil)
//        print(filePath)

        imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        //print(imageURL)
        picker.dismiss(animated:false)
    }

}
//회원가입 정보 유효성 검사
extension RegisterViewController : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            case idTF:
                if (idTF.text?.isEmpty)!{
                    lblId.text = "아이디가 비어있습니다!"
                }else if idTF.text!.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil{
                    lblId.text = "아이디는 대/소문자와 숫자만 사용할 수 있습니다."
                }else{
                    lblId.textColor = UIColor.green
                    lblId.text = "사용가능한 아이디입니다."
                }
            break
            
            case nicknameTF:
                if (nicknameTF.text?.isEmpty)!{
                    lblname.text = "넥에임이 비어있습니다!"
                }else{
                    lblname.textColor = UIColor.green
                    lblname.text = "사용가능한 닉네임입니다."
                }
            break
            case pwTF:
                let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,0}")
                
                if (pwTF.text?.isEmpty)!{
                    lblpw.text = "비밀번호가 비어있습니다!"
                }else if !passwordTest.evaluate(with: pwTF.text!){
                    lblpw.text = "비밀번호는 대,소문자, 숫자의 조합이고 적어도 8자!"
                }else {
                    lblpw.textColor = UIColor.green
                    lblpw.text = "사용가능한 비밀번호입니다."
                    
                }
            break
            
            case pwConTF:
                if (pwConTF.text?.isEmpty)! {
                    lblpwCon.text = "비밀번호가 비어있습니다!"
                    lblpwCon.adjustsFontSizeToFitWidth = true
                    lblpwCon.textColor = UIColor.red
                }else if pwConTF.text! != pwTF.text!{
                    lblpwCon.text = "비밀번호가 동일하지 않습니다!"
                    lblpwCon.adjustsFontSizeToFitWidth = true
                    lblpwCon.textColor = UIColor.red
                }else{
                    lblpwCon.textColor = UIColor.green
                    lblpwCon.text = "사용가능한 비밀번호입니다."
                }
            break
        default:
            ()
        }
    }
    
}
