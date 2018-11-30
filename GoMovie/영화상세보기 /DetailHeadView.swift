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
    @IBOutlet weak var subview: UIView!
    //댓글 쓰기
    @IBAction func writReview(_ sender: Any) {
    }
    //극장 찾기
    @IBAction func theaterMove(_ sender: Any) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let displayMapViewController = appDelegate.displayMapViewController
        
        //비동기적으로 푸시
        DispatchQueue.main.async {
            appDelegate.navi?.pushViewController(displayMapViewController!, animated: true)
        }
    }
    
    static func showInTableView(tableView : UITableView, movieVO : MovieVO) -> DetailHeadView{
        let detailHeadView = Bundle.main.loadNibNamed("DetailHeadView", owner: nil, options: nil)?[0] as! DetailHeadView
        detailHeadView.dataLoading(tableView: tableView, movieVO: movieVO)
        return detailHeadView
    }
    func dataLoading(tableView : UITableView, movieVO : MovieVO){
        
        let url = "https://api.themoviedb.org/3/movie/\(movieVO.movieId!)?api_key=0d18b9a2449f2b69a2489e88dd795d91&language=ko-KR"
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
                self.poster.image = UIImage(data: movieVO.posterData!)
                self.lblTitle.text = (jsonObject["title"] as! NSString) as String
                self.lblGenres.text = genres
                self.lblRelease.text = (jsonObject["release_date"] as! NSString) as String
                self.lblVoteAverage.text = "\(jsonObject["vote_average"] as! Double)"
                self.lblVoteCount.text = "\(jsonObject["vote_count"] as! Int)명"
                self.lblOverview.text = (jsonObject["overview"] as! NSString) as String
                
            case .failure(let error):
                print(error)
            }
        })

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = subview.frame.size.height

    }

}
