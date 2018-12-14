//
//  DetailViewController.swift
//  GoMovie
//
//  Created by 503-03 on 27/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class DetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var detailHeadView : DetailHeadView!
    
    //상위 뷰 컨트롤러에서 넘겨준 데이터 저장
    var movie = [Dictionary<String, Any>]()

    //댓글 데이터 저장 객체
    var reviewlist : [ReviewVO] = [ReviewVO]()

    //댓글 가져오기
    func getReviews(movieId : Int){
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/reviews/reviewlist?movieId=\(movieId)")
        request.responseJSON(completionHandler: {(response) in
            switch response.result{
            case.success:
                let dic = response.result.value as! NSDictionary
                let count = dic["count"] as! Int
                self.detailHeadView.lblcount.text = "\(count)개"
                let reviews = dic["reviews"] as! NSArray
                //기존데이터 삭제
                self.reviewlist.removeAll()
                for re in reviews{
                    let review = re as! NSDictionary
                    let reviewVO : ReviewVO  = ReviewVO()
                    reviewVO.content = review["content"] as? String
                    reviewVO.dispdate = review["dispdate"] as? String
                    reviewVO.likecnt = review["likecnt"] as? Int
                    reviewVO.nickname = review["nickname"] as? String
                    reviewVO.rno = review["rno"] as? Int
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
                break
            case.failure(let error):
                print("댓글 요청실패:\(error)")
                break
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let detailHeadView = DetailHeadView.showInTableView(detailViewController: self, movie: movie)
        self.detailHeadView = detailHeadView
        self.tableView.tableHeaderView = detailHeadView

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReviews(movieId: movie[0]["movieId"] as! Int)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.sizeToFit()
        let review = reviewlist[indexPath.row]
        cell.rno = review.rno
        cell.cnt = review.likecnt
        cell.photo.image = review.image
        cell.photo.layer.cornerRadius = (cell.photo.frame.width/2)
        cell.photo.layer.borderWidth = 0
        cell.photo.layer.masksToBounds = true
        cell.nickname.text = review.nickname!
        cell.nickname.sizeToFit()
        cell.likecnt.text = "\(review.likecnt!)"
        cell.likecnt.sizeToFit()
        cell.content.text = review.content!
        cell.content.sizeToFit()
        cell.dispdate.text = review.dispdate!
        
        return cell
    }

}


