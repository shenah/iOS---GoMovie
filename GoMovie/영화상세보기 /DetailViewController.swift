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

    @IBOutlet weak var tableView: UITableView!
    var detailHeadView : DetailHeadView!
    
    //상위 뷰 컨트롤러에서 넘겨준 데이터 저장
    var movie = [Dictionary<String, Any>]()

    //댓글 데이터 저장 객체
    var reviewlist : [ReviewVO] = [ReviewVO]()

    //댓글 가져오기
    func getReviews(movieId : Int){
         print("start getreviews")
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/reviews/reviewlist?movieId=\(movieId)")
        request.responseJSON(completionHandler: {(json) in
            let dic = json.result.value as! NSDictionary
            let count = dic["count"] as! Int
            //self.movie.append(["count" : count])
            self.detailHeadView.lblcount.text = "\(count)개"
            let reviews = dic["reviews"] as! NSArray
            for re in reviews{
                let review = re as! NSDictionary
                print(review)
                var reviewVO : ReviewVO  = ReviewVO()
                reviewVO.content = review["content"] as! String
                reviewVO.dispdate = review["dispdate"] as! String
                reviewVO.likecnt = review["likecnt"] as! Int
                reviewVO.nickname = review["nickname"] as! String
                reviewVO.rno = review["rno"] as! Int
                print(review["image"] as! String)
                if review["image"] as! String != "null"{
                    
                    let image = review["image"] as! String
                    let url = URL(string: "http://192.168.0.113:8080/MobileServer/memberimage/\(image)")
                    let imageData = try! Data(contentsOf: url!)
                   reviewVO.image = UIImage(data: imageData)
                }else{
                    reviewVO.image = UIImage(named: "account.jpg")
                }
                self.reviewlist.append(reviewVO)
            }
            self.tableView.reloadData()
        })
        print("end getreviews")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        //테이블의 HeadView 설정
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewdidappear")
         getReviews(movieId: movie[0]["movieId"] as! Int)
        
        let detailHeadView = DetailHeadView.showInTableView(detailViewController: self, movie: movie)
        self.detailHeadView = detailHeadView
        tableView.tableHeaderView = detailHeadView
        self.tableView.reloadData()
    }

}
extension DetailViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberofrows")
        return reviewlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = reviewlist[indexPath.row]
        cell.photo.image = review.image
        cell.photo.layer.cornerRadius = (cell.photo.frame.width/2)
        cell.photo.layer.borderWidth = 0
        cell.photo.layer.masksToBounds = true

        cell.nickname.text = review.nickname!
        cell.likecnt.text = "\(review.likecnt!)"
        cell.likecnt.sizeToFit()
        cell.content.text = review.content!
        cell.content.sizeToFit()
        cell.dispdate.text = review.dispdate!
        
        
        return cell
    }
    
    //cell 높이 설정
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//
//        return 140
//    }
}

