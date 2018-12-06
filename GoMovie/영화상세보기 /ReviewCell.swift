//
//  ReviewCell.swift
//  GoMovie
//
//  Created by 503-03 on 03/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class ReviewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var likecnt: UILabel!
    @IBOutlet weak var dispdate: UILabel!
    
    @IBAction func like(_ sender: Any) {
//        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/reviews/myreviews", method: .get, parameters: ["id" : id], encoding: URLEncoding.default, headers: nil)
//        request.responseJSON(completionHandler: {(response) in
//            print(response)
//            switch response.result{
//            case.success:
//                let dic = response.result.value as! NSDictionary
//                self.count = dic["count"] as! Int
//                let reviews = dic["reviews"] as! NSArray
//                for re in reviews{
//                    let review = re as! NSDictionary
//                    let reviewVO : ReviewVO  = ReviewVO()
//                    reviewVO.content = review["content"] as? String
//                    reviewVO.dispdate = review["dispdate"] as? String
//                    reviewVO.likecnt = review["likecnt"] as? Int
//                    reviewVO.rno = review["rno"] as? Int
//                    reviewVO.movieTitle = review["movieTitle"] as? String
//                    self.list.append(reviewVO)
//                    self.tableView.reloadData()
//                }
//                break
//            case.failure(let error):
//                print("댓글 요청실패:\(error)")
//                break
//            }
//            
//        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
