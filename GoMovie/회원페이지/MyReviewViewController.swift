//
//  MyReviewViewController.swift
//  GoMovie
//
//  Created by 503-03 on 06/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
class MyReviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //댓글 정보 받을 객체 생성
    var list : [ReviewVO]?
    
    var util : Util = Util()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.sizeToFit()
    }
    //서버에 댓글 삭제 요청 
    func deleteReview(rno : Int) -> Bool{
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/reviews/deletereview", method: .delete, parameters: ["rno": rno], encoding: URLEncoding.default, headers: nil)
        var result : Bool = false
        //결과
        request.responseJSON{
            response in
            switch response.result{
            case .success:
                let jsonObject = response.result.value as! NSDictionary
                if jsonObject["deletereview"] != nil  {
                    self.util.alert(controller: self, message: "댓글 삭제 성공!")
                    result = true
                }else{
                    self.util.alert(controller: self, message: "댓글 삭제 실패!")
                }
            case .failure(let error):
                print("댓글 삭제요청error: \(error)")
                
            }
        }
        return result
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
        cell.title.adjustsFontSizeToFitWidth = true
        cell.content.text = review.content!
        cell.content.sizeToFit()
        cell.time.text = review.dispdate!
        cell.time.adjustsFontSizeToFitWidth = true
        return cell
    }
    //편집 기능을 실행할 때 보여질 버튼을 설정하는 메소드
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    //셀 편집할 때 호출되는 메소드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        //삭제할 셀의 댓글 번호 가져오기
        var rno = list![indexPath.row].rno!
        print(rno)
        //서버의 데이터를 삭제 성공한 후 배열 및 테이블의 행을 삭제 
        if deleteReview(rno: rno) {
            list?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
