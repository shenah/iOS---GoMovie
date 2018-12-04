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
    
    //영화 상세정보 객체
    var movie = [String: Any]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backdropImg: UIImageView!

    //극장 찾기
    @IBAction func theaterMove(_ sender: Any) {
        let displayMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "DisplayMapViewController") as! DisplayMapViewController
        //비동기적으로 푸시
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(displayMapViewController, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //DetailHeadView에서 버튼 동작할 수 있게 컨트롤러 저장
        appDelegate.navi = self.navigationController
        appDelegate.displayMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "DisplayMapViewController") as! DisplayMapViewController
        appDelegate.detailViewController = self
        
        //테이블의 HeadView 설정
        let detailHeadView = DetailHeadView.showInTableView(tableView: tableView, movie: movie) as! DetailHeadView
        tableView.tableHeaderView = detailHeadView
        self.title = detailHeadView.lblTitle.text
        tableView.delegate = self
    }

}
extension DetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

