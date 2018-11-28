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

    @IBOutlet weak var mapView: MKMapView!
    //위치정보 사용 객체 변수 선언
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //위치정보 사용 객체 생성
        locationManager = CLLocationManager()
        //위치정보를 사용 권한을 묻는 대화상자
        locationManager?.requestWhenInUseAuthorization()
        //mapview 현재 위치를 출력
        mapView.showsUserLocation = true
        
    }
    
}
extension ViewController : MKMapViewDelegate{
    //사용자의 위치가 변경되는 경우 호출되는 메소드
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
}
