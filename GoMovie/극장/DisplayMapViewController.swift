//
//  DisplayMapViewController.swift
//  GoMovie
//
//  Created by 503-03 on 28/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class DisplayMapViewController: UIViewController, CLLocationManagerDelegate {
    //공동으로 사용할 함수를 사용하기 위한 객체 생성
    var util = Util()
    
    //검색 결과 저장할 배열 생성
    var matchingItems : [MKMapItem] = [MKMapItem]()

    let tableView : UITableView = UITableView()
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    //위치정보 사용 객체 변수 선언
    var locationManager : CLLocationManager!
    
    //검색하는 메소드
    func performSearch(){
        //요청 객체 만들기
        let request = MKLocalSearch.Request()
        //검색어와 검색영역 설정
        request.naturalLanguageQuery = searchbar.text
        request.region = mapView.region
        //검색 객체 만들기
        let search = MKLocalSearch(request: request)
        //검색 요청과 핸들러
        search.start(completionHandler: {(respose, error) in
            if error != nil{
                self.util.alert(controller: self, message: "검색중 에러")
            }else if respose?.mapItems.count == 0{
                 self.util.alert(controller: self, message: "검색 결과 없음")
            }else{
                //전체 데이터 순회
                for item in respose!.mapItems{
                    //데이터 저장
                    self.matchingItems.append(item)
                    //맵에 출력
                    let annotation = MKPointAnnotation()
                    //어노테이션 정보 생성
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name!
                    self.mapView.addAnnotation(annotation)
                }
                
                self.tableView.reloadData()
                
            }
        })
    }
    
    // 결과 출력
    func resultAlert(){
        let alert = UIAlertController(title: "경로 가져오기", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        //대화상자에 삽입할 뷰 컨트롤러 만들기
        let contentVC = UIViewController()
        //검색 결과 출력할 테이블 뷰 생성
        
        tableView.contentSize.height = 200
        contentVC.view.addSubview(tableView)
        contentVC.preferredContentSize = CGSize(width: tableView.frame.height, height: tableView.frame.width)
        self.tableView.reloadData()
        //대화상자에 삽입
        alert.setValue(contentVC, forKey: "contentViewController")
        //대화 상자 출력
        self.present(alert, animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //위치정보 사용 객체 생성
        locationManager = CLLocationManager()
        //위치정보를 사용 권한을 묻는 대화상자
        locationManager?.requestWhenInUseAuthorization()
        //mapview 현재 위치를 출력
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        searchbar.becomeFirstResponder()
        searchbar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchbar.resignFirstResponder()
    }
    
}
extension DisplayMapViewController : MKMapViewDelegate{
    //사용자의 위치가 변경되는 경우 호출되는 메소드
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
}

extension DisplayMapViewController : UISearchBarDelegate{
    //SearchButton을 클릭했을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        // 맥 뷰의 어노테이션 모두 제거
        mapView.removeAnnotations(mapView.annotations)
        //검색 메소드 호출
        performSearch()
        resultAlert()
    }
    
    //ResultsListButton 클릭했을 때
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        resultAlert()
    }
}
extension DisplayMapViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(matchingItems.count)
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = matchingItems[indexPath.row]
        print(item.name)
        cell.textLabel?.text = item.name!
        
        cell.detailTextLabel?.text = "\(item.placemark.country!) \(item.placemark.locality!) \(item.placemark.thoroughfare!)"
        print(cell.detailTextLabel?.text)
        return cell
    }
    
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}

