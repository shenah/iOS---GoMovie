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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "주변 검색"
        //위치정보 사용 객체 생성
        locationManager = CLLocationManager()
        //위치정보 사용 권한을 묻는 대화상자 출력
        locationManager.requestWhenInUseAuthorization()
        //맵 뷰에 현재 위치를 출력
        mapView.showsUserLocation = true
        //mapView의 delegate 설정
        mapView.delegate = self
        
        searchbar.becomeFirstResponder()
        searchbar.delegate = self
        
        
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
    }
    
    //ResultsListButton 클릭했을 때
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        let thearterViewController = self.storyboard?.instantiateViewController(withIdentifier: "ThearterViewController") as! ThearterViewController
        thearterViewController.items = matchingItems
        self.navigationController?.pushViewController(thearterViewController, animated: true)
    }
}


