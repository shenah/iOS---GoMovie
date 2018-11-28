//
//  ThearterViewController.swift
//  GoMovie
//
//  Created by 503-03 on 27/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class ThearterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //파싱한 결과를 저장할 변수
    var data = [NSDictionary]()
    //데이터를 읽을 시작 위치
    var startLocation = 1
    
    //웹에서 데이터 다운로드
    func download(){
        let addr = "http://swiftapi.rubypaper.co.kr:2029/theater/list?s_page=\(startLocation)&s_list=10"
        let url = URL(string: addr)
        
        //데이터가 utf-8로 되어있지 않아서 Data로 가져오지 않고 String으로 데이터 받기
        //let apidata = try! Data(contentsOf: url!)
        let stringData = try! NSString(contentsOf: url!, encoding: 0x80_000_422)
        //문자열을 바이트 배열로 변환
        let encdata = stringData.data(using: String.Encoding.utf8.rawValue)
        let jsonObject = try! JSONSerialization.jsonObject(with: encdata!, options: []) as! NSArray
        //print(jsonObject)
        //배열의 데이터를 순회하면서 데이터를 self.data에 추가
        for imsi in jsonObject{
            print(imsi)
            self.data.append(imsi as! NSDictionary)
        }
}
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        download()
        self.navigationItem.title = "영화관 목록"
        self.title = "영화관 목록"
        self.tableView.reloadData()
    }
}

extension ThearterViewController : UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //행의 개수를 설정하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThearterTableViewCell", for: indexPath) as! ThearterTableViewCell
        //출력할 데이터 찾아오기
        let theater = self.data[indexPath.row]
        //데이터 출력
        cell.lblname.text = theater["상영관명"] as? String
        cell.lblPhone.text = theater["연락처"] as? String
        cell.lblAddr.text = theater["소재지도로명주소"] as? String
        return cell
    }
    
    //셀의 높이를 설정하는 메소드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //셀을 선택했을 때 호출되는 메소드
    
}
