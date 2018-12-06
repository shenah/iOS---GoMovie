//
//  DetailHeadView.swift
//  GoMovie
//
//  Created by 503-03 on 28/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class DetailHeadView: UIView {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblRelease: UILabel!
    @IBOutlet weak var lblVoteAverage: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblcount: UILabel!
    @IBOutlet weak var subview: UIView!
    
    
    //detailviewcontroller를 저장할 변수와 상위 뷰 컨트롤에서 넘겨준 데이터
    var detailViewController : UIViewController?
    var movie : [Dictionary<String, Any>]?
    
    //댓글 쓰기
    @IBAction func writReview(_ sender: Any) {
        //로그인 확인
        if UserDefaults.standard.string(forKey: "id") == nil{
            
            //로그인 알림
            let alert = UIAlertController(title: "댓글을 남기려면 로그인 해야 합니다.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "로그인", style: .default, handler: {(action) in
                //로그인 뷰 컨트롤러 가져오기
                let loginViewController = self.detailViewController?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.detailViewController?.present(loginViewController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            detailViewController?.present(alert, animated: true)
            
        }else{
            //대화상자에 삽입할 뷰 컨트롤러 만들기
            let contentVC = UIViewController()
            //contentVC 사이즈 설정
            
            //댓글 달기 위한 textView
            let textView = UITextView()
            textView.frame = CGRect(x: 0, y: 0, width: 310, height: 200)
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.clear.cgColor
            textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            contentVC.preferredContentSize = CGSize(width: textView.frame.width, height: textView.frame.height)
            //텍스트 뷰 삽입
            contentVC.view.addSubview(textView)
           
            //parameter
            let memberId = UserDefaults.standard.string(forKey: "id")!
            let movieId = movie![0]["movieId"] as! Int
            let movieTitle = lblTitle.text!
            
            
            //대화상자 만들기 
            let alert = UIAlertController(title: "댓글을 작성하세요!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(action) in
                guard textView.text.isEmpty == false else{
                    self.showToast(message: "댓글 추가 실패! 내용을 입력하세요!")
                    return
                }
                
                let url = "http://192.168.0.113:8080/MobileServer/reviews/addreview"
                let request = Alamofire.request(url, method: .post, parameters: ["memberId": memberId, "movieId": movieId, "movieTitle": movieTitle, "content": textView.text as? String] , encoding: URLEncoding.default, headers: nil)
                request.responseJSON(completionHandler: {(json) in
                    print(textView.text)
                    let result = json.result.value as! NSDictionary
                    if result["addreview"] != nil  {
                        self.showToast(message: "댓글 추가 성공!")
                        
                    }else{
                        self.showToast(message: "댓글 추가 실패!")
                    }})
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            //대화상자에 삽입
            alert.setValue(contentVC, forKey: "contentViewController")
            detailViewController?.present(alert, animated: true)
        }
        
    }
    
    //극장 찾기
    @IBAction func theaterMove(_ sender: Any) {
        
        //지도 - DisplayMapViewController 가져오기
        let displayMapViewController = detailViewController?.storyboard?.instantiateViewController(withIdentifier: "DisplayMapViewController")
        
        //비동기적으로 푸시
        DispatchQueue.main.async {
            self.detailViewController?.navigationController?.pushViewController(displayMapViewController!, animated: true)
        }
    }
    
    static func showInTableView(detailViewController : UIViewController, movie: [Dictionary<String, Any>]) -> DetailHeadView{
        let detailHeadView = Bundle.main.loadNibNamed("DetailHeadView", owner: nil, options: nil)?[0] as! DetailHeadView
        detailHeadView.dataLoading(detailViewController : detailViewController, movie: movie)
        return detailHeadView
    }
    
    //데이터 가져오기
    func dataLoading(detailViewController : UIViewController, movie : [Dictionary<String, Any>]){
        self.detailViewController = detailViewController
        self.movie = movie
        let url = "https://api.themoviedb.org/3/movie/\(movie[0]["movieId"]!)?api_key=0d18b9a2449f2b69a2489e88dd795d91&language=ko-KR"
        let request = Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        request.responseJSON(completionHandler: {
            response in
            //json데이터 파싱
            //데이터가 있다면
            switch response.result {
            case .success:
                let jsonObject = response.result.value as! NSDictionary
                //데이터 가져오기
                let genresObject = jsonObject["genres"] as! [NSDictionary]
                var genres = ""
                for dic in genresObject{
                    let name = (dic["name"] as! NSString) as String
                    genres.append(contentsOf: "\(name) ")
                }
                self.poster.image = UIImage(data: movie[1]["posterData"] as! Data)
                self.lblTitle.text = (jsonObject["title"] as! NSString) as String
                self.lblGenres.text = genres
                self.lblRelease.text = (jsonObject["release_date"] as! NSString) as String
                self.lblVoteAverage.text = "\(jsonObject["vote_average"] as! Double)"
                self.lblVoteCount.text = "\(jsonObject["vote_count"] as! Int)명"
                self.lblOverview.text = (jsonObject["overview"] as! NSString) as String
                //self.lblcount.text = movie[2]["count"] as! String
            case .failure(let error):
                print(error)
            }
        })

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblOverview.sizeToFit()
        self.frame.size.height = subview.frame.size.height
       
    }
    
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: detailViewController!.view.frame.size.width/2 - 75, y: detailViewController!.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.sizeToFit()
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        detailViewController!.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

