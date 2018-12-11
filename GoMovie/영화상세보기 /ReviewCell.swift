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
    
    //댓글 번호, 좋아요 개수를 저장하는 변수
    var rno : Int?
    var cnt : Int?
    @IBAction func like(_ sender: Any) {
        
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/reviews/like", method: .post, parameters: ["rno" : rno!], encoding: URLEncoding.default, headers: nil)
        request.responseJSON(completionHandler: {(response) in
            switch response.result{
            case.success:
                let result = response.result.value as! NSDictionary
                if result["like"] != nil {
                    self.cnt = self.cnt! + 1
                    self.likecnt.text = "\(self.cnt!)"
                }
                break
            case.failure(let error):
                print("좋아요 요청실패:\(error)")
                break
            }
            
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
