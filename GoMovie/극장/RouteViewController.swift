//
//  RouteViewController.swift
//  GoMovie
//
//  Created by 503-03 on 14/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class RouteViewController: UIViewController {

    //상위에서 선택한 MapItem 가져오기
    var mapItem : MKMapItem?
    
    //위치정보를 사용하기 위한 객체 생성
    var locationManager = CLLocationManager()
    
    //위치정보를 저장할 변수
    var userLocation : CLLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "경로"
        //mapview의 delegate, datasource 설정
        mapView.delegate = self
        mapView.showsUserLocation = true
        //정밀도 설정 - 높으면 베터리 소모량이 많음
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //delegate 설정
        locationManager.delegate = self
        //위치정보 사용여부를 확인
        locationManager.requestLocation()
    }

}
extension RouteViewController : MKMapViewDelegate, CLLocationManagerDelegate{
    //지도에 경로를 출력해주는 사용자 정의 메소드
    func showRoute(_ response : MKDirections.Response){
        //지도 위에 경로 출력
        for route in response.routes{
            //지도에 오버레이 출력 - view 위의 view
            mapView.addOverlay(route.polyline, level:MKOverlayLevel.aboveRoads )
            //경로를 콘솔에 출력
            for step in route.steps{
                print(step.instructions)
            }
        }
        //지도를 사용자의 위치에 따라 이동하도록 만들기
        if let coordinate = userLocation?.coordinate{
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
            mapView.setRegion(region, animated: true)
        }
    }
    //2개의 위치정보를 가지고 경로를 찾아오는 사용자 정의 메소드
    func getDirections(){
        //경로를 찾아주는 객체 만들기
        let request = MKDirections.Request()
        //위치 설정
        request.source = MKMapItem.forCurrentLocation()
        if let mapItem = mapItem{
            request.destination = mapItem
        }
        
        //옵션 설정 - 반대 경로는 찾지 않기
        request.requestsAlternateRoutes = false
        
        //옵션을 가지고 길찾기를 수행해 줄 객체를 생성
        let directions = MKDirections(request: request)
        
        //길찾기 시작
        directions.calculate(completionHandler: {(response, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let response = response{
                    self.showRoute(response)
                }
            }
        })
    }
    
    //위치정보를 가져오는데 성공했을 때 호출되는 메소드
    //CLLocationManagerDelegate 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //가장 마지막의 위치를 저장
        userLocation = locations[locations.count-1]
        //길찾기 메소드 호출
        getDirections()
    }
    //위치정보를 가져오는데 실패했을 때 호출되는 메소드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    
    //맵 뷰에 오버레이를 할 때 호출되는 메소드
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
}
