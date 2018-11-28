//
//  DetailViewController.swift
//  GoMovie
//
//  Created by 503-03 on 27/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class DetailViewController: UIViewController {
    
    var movieId : Int?
    var movieTitle : String?
    var posterData : Data?
    
    @IBOutlet weak var indicatiorView: UIActivityIndicatorView!
    @IBOutlet weak var backdropImg: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblRelease: UILabel!
    @IBOutlet weak var lblVoteAverage: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    @IBAction func writReview(_ sender: Any) {
    }
    //극장 찾기
    @IBAction func theaterMove(_ sender: Any) {
        let displayMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "DisplayMapViewController") as! DisplayMapViewController
        //비동기적으로 푸시
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(displayMapViewController, animated: true)
        }
        
    }   //댓글 쓰기
    
    //데이터를 다운로드 받는 메소드
    func download(){
        //linkUrl의 데이터 있으면 예이가 발생하지 않도록 하기 위해서 이런 형태로 코드를 작성
        //java 코드라면 변수 != null
        //linkUrl에 데이터가 있다면
        if let id = movieId{
            
            let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=0d18b9a2449f2b69a2489e88dd795d91&language=ko-KR"
            print(url)
            let request = Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            request.responseJSON(completionHandler: {
                response in
                //json데이터 파싱
                //데이터가 있다면
                if let jsonObject = response.result.value as? NSDictionary{
                    //데이터 가져오기
                    let genres = jsonObject["genres"] as! [NSDictionary]
                    var str = ""
                    for dic in genres{
                        let name = (dic["name"] as! NSString) as String
                        str.append(contentsOf: "\(name) ")
                    }
                    self.lblGenres.text = str
                    
                    self.lblRelease.text = (jsonObject["release_date"] as! NSString) as String
                    
                    self.lblVoteAverage.text = "\(jsonObject["vote_average"] as! Double)"
                    self.lblVoteCount.text = "\(jsonObject["vote_count"] as! Int)"
                    self.lblOverview.text = (jsonObject["overview"] as! NSString) as String
                    
                    //처음 배경 이미지만 가져오기
                    
                    /*let company = (jsonObject["production_companies"] as! [NSDictionary]).first!
                    print(company)
                    print(company["logo_path"])
                    guard company["logo_path"] !=  {
                        let path = (company["logo_path"] as! NSString) as String
                        let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
                        let pathData = try! Data(contentsOf: url!)
                        self.backdropImg.image = UIImage(data: pathData)
                    }*/
                    
                    //movie 이름 출력
                    self.lblTitle.text = self.movieTitle!
                    //포스터 출력
                    self.poster.image = UIImage(data: self.posterData!)
                }else{
                    print("데이터 없음")
                }
            })
            
        }else{
            let alert = UIAlertController(title: "데이터가 없습니다.", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            self.present(alert, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        download()
        self.title = movieTitle
        
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
/*extension DetailViewController : WKNavigationDelegate, WKUIDelegate{
 // 웹뷰가 로딩을 시작했을 때
 func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
 self.indicatiorView.startAnimating()
 }
 
 //웹뷰가 로딩을 종료했을 때
 func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
 self.indicatiorView.stopAnimating()
 }
 
 //웹뷰 로딩 실패 했을 때
 func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
 self.indicatiorView.stopAnimating()
 print(error)
 }
 }*/

