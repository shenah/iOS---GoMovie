//
//  MovieListViewController.swift
//  GoMovie
//
//  Created by 503-03 on 26/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import ESPullToRefresh

class MovieListViewController: UIViewController {

    
    
    @IBOutlet weak var playingbtn: UIButton!
    @IBOutlet weak var comingbtn: UIButton!
    @IBOutlet weak var playinglbl: UILabel!
    @IBOutlet weak var cominglbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //공용 메소드 사용
    var util : Util = Util()
    
    // 출력할 데이터 parameter
    var param : String = "now_playing"
    
    //cell의 출력할 데이터를 저장하는 객체
    lazy var coreList : [NSManagedObject] = [NSManagedObject]()

    //CoreData 사용하기 위한 MovieListDAO 객체 생성
    var movieDao = MovieListDAO()
    
    var playingPage = 1
    var comingPage = 1

    // "현재 상영중" 버튼 눌렀을 때 이벤트
    @IBAction func nowplaying(_ sender: Any) {
        param = "now_playing"
        //디자인 변경
        comingbtn.setTitleColor(UIColor.lightGray, for: .normal)
        cominglbl.backgroundColor = UIColor.white
        playinglbl.backgroundColor = UIColor.black
        //"now_playing" 데이터만 가져오고 reloadData
        coreList = movieDao.getMoviesWith(param, ascending: false)
        self.tableView.reloadData()
    }
    // "개봉예정" 버튼 눌렀을 때 이벤트
    @IBAction func upcoming(_ sender: Any) {
        param = "upcoming"
        //디자인 변경
        playingbtn.titleLabel?.textColor = UIColor.lightGray
        playinglbl.backgroundColor = UIColor.white
        comingbtn.setTitleColor(UIColor.black, for: .normal)
        cominglbl.backgroundColor = UIColor.black
        
        //"upcoming" 데이터만 가져오고 reloadData
        coreList = movieDao.getMoviesWith(param, ascending: true)
        self.tableView.reloadData()
    }
    
    //server에서 영화목록 데이터를 가져와 CoreData에 저장하는 메소드
    func download(_ param : String, page: Int){
        //데이터 요청 url
        let url = "https://api.themoviedb.org/3/movie/\(param)?api_key=0d18b9a2449f2b69a2489e88dd795d91&language=ko-KR&region=KR&page=\(page)"
        
        let request = Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default , headers: nil)
        request.responseJSON(completionHandler: {
            response in
            switch response.result{
            case.success:
                //json데이터 파싱
                //데이터가 있다면
                if let jsonObject = response.result.value as? NSDictionary{
                    //results 키 가져오기
                    let movies = jsonObject["results"] as! [NSDictionary]
                    //coredata에 저장
                    for movieDic in movies{
                        self.movieDao.save(movieDic, param)
                    }

                    //totalpage 가져오기
                    let totalPages = jsonObject["total_pages"] as! Int
                    
                    //시작 화면 데이터 가져오기
                    if param == "now_playing" {
                        self.coreList = self.movieDao.getMoviesWith(param, ascending: false)
                        self.tableView.reloadData()
                    }
                }else{
                    print("데이터 없음")
                }
            case.failure(let error):
                print("데이터 가져오기 실패:\(error)")
            }
        })
    }
    
    //refreshControl이 화면에 보여질 때 호출될 메소드
    @objc func handleRequest(_ refreshControl:UIRefreshControl){
        //페이지 번호를 1 증가 시키고 데이터를 다시 받아오기
        if param == "now_playing" {
            playingPage = playingPage + 1
            self.download(param, page: playingPage)
        }else{
            comingPage = comingPage + 1
            self.download(param, page: comingPage)
        }
        
        //refreshControl 애니메이션 중지
        refreshControl.endRefreshing()
        refreshControl.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //데이터 다운로드 - 인터넷 사용 가능할 때
        if NetworkReachabilityManager()!.isReachable {
            //기존 CoreData의 데이터 모두 삭제 성공하면 다운로드 시작 
            if movieDao.deleteAll() {
                self.download("now_playing", page: playingPage)
                self.download("upcoming", page: comingPage)
            }
        }
        
        //로그인하지 않았을 때
        if UserDefaults.standard.string(forKey: "id") == nil {
            //로그인 알림
            util.loginAlert(controller: self, message: "로그인하시겠습니까?")
        }
        
        self.tabBarController?.title = "영화정보"
        tableView.delegate = self
        tableView.dataSource = self
        //refreshControl 생성
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(MovieListViewController.handleRequest(_:)), for: .valueChanged)
        
        //MARK:下拉刷新数据
//        tableView.es_addPullToRrefresh {
//            [weak self] in
//            Alamofire.request((self?.url)!, method: .get, parameters: ["tag":(self?.tag)!,"start":0,"count":(self?.pageSize)],encoding: URLEncoding.default).responseJSON {
//                response in
//
//                switch response.result {
//                case .success:
//                    self?.books = JSON(response.result.value)["subjects"]
//                    self?.page = 1
//                    self?.tableView.reloadData()
//                    self?.tableView.es_stopPullToRefresh(completion: true)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
        
    }
    
}
extension MovieListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        //각 행에 출력할 데이터 가져오기
        let movieData = coreList[indexPath.row]
        //coreData에 저장된 데이터 가져오기
        cell.poster.image = UIImage(data: movieData.value(forKey: "posterData") as! Data)
        cell.title.text = movieData.value(forKey: "title") as? String
        cell.title.adjustsFontSizeToFitWidth = true
        cell.releaseDate.text = movieData.value(forKey: "releaseDate") as? String

        let voteAverage = movieData.value(forKey: "voteAverage") as! Double
        //평점이 Double 타입을 소수점 1자리까지 남겨서 출력
        cell.voteAverage.text = "평점: \(String(format: "%.1f", voteAverage))"
        
        //비동기적으로 별점 이미지 출력
        DispatchQueue.main.async {
            //if voteAverage != 0.0{
                RatingView.showInView(view: cell.ratingView, value: voteAverage/2)
//            }else{
//                RatingView.showNORating(view: cell.ratingView)
//            }
        }
        return cell
    }
    
    //cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 172
    }
    
    //cell를 선택했을 때 호출되는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        //선택한 행의 데이터 찾아오기
        let movieData = self.coreList[indexPath.row]
        //상세보기 화면에 데이터 전달
        let movieId = movieData.value(forKey: "movieId") as! Int
        let posterData = movieData.value(forKey: "posterData") as! Data
        detailViewController.movie.append(["movieId": movieId])
        detailViewController.movie.append(["posterData": posterData])

        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
