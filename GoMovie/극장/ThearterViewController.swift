//
//  ThearterViewController.swift
//  GoMovie
//
//  Created by 503-03 on 27/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import MapKit
class ThearterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //검색 결과를 저장할 변수
    var items : [MKMapItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "검색결과 목록"
        self.tableView.reloadData()
    }
}

extension ThearterViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThearterTableViewCell", for: indexPath) as! ThearterTableViewCell
        
        //출력할 데이터 찾아오기
        let item = items![indexPath.row]
        
        //장소명 가져오기
        cell.lblname.text = item.name!
        
        //전화번호 가져오기
        if item.phoneNumber != nil {
            cell.lblPhone.text = item.phoneNumber!
        }else{
            cell.lblPhone.text = "없음"
        }
        
        //주소 가져오기
        var address : String = item.placemark.country!
        if item.placemark.locality != nil {
            address += " " + item.placemark.locality!
        }
        if item.placemark.thoroughfare != nil {
            address += " " + item.placemark.thoroughfare!
        }
        if item.placemark.subThoroughfare != nil {
            address += " " + item.placemark.subThoroughfare!
        }
        
        cell.lblAddr.text = address
        return cell
    }
    
    //셀의 높이를 설정하는 메소드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //셀을 선택했을 때 호출되는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routeViewController = self.storyboard?.instantiateViewController(withIdentifier: "RouteViewController") as! RouteViewController
        //행 번호에 해당하는 데이터 넘겨주기
        routeViewController.mapItem = items![indexPath.row]
        //화면 이동
        self.navigationController?.pushViewController(routeViewController, animated: true)
    }
}
