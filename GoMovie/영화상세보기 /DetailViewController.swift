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
    var movieVO = MovieVO()
    
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
        self.title = movieVO.title
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        appDelegate.navi = self.navigationController
        
        appDelegate.displayMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "DisplayMapViewController") as! DisplayMapViewController
        
        let detailHeadView = DetailHeadView.showInTableView(tableView: tableView, movieVO: movieVO) as! DetailHeadView
        tableView.tableHeaderView = detailHeadView
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

