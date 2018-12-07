//
//  MyReviewViewController.swift
//  GoMovie
//
//  Created by 503-03 on 06/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class MyReviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //댓글 정보 받을 객체 생성
    var list : [ReviewVO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.sizeToFit()
    }
    
}
extension MyReviewViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyReviewCell", for: indexPath) as! MyReviewCell
        //데이터 가져오기
        let review = list![indexPath.row]
        cell.title.text = "\(review.movieTitle!)  좋아요 \(review.likecnt!)개"
        cell.content.text = review.content!
        cell.content.sizeToFit()
        cell.time.text = review.dispdate!
        cell.time.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    //cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell = tableView.cellForRow(at: indexPath) as! MyReviewCell
        return 72.5 + cell.content.frame.height
    }
    
}
