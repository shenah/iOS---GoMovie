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
class MovieListViewController: UIViewController {

    //AppDelegate 객체에 대한 참조 변수
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var playingbtn: UIButton!
    @IBOutlet weak var comingbtn: UIButton!
    @IBOutlet weak var playinglbl: UILabel!
    @IBOutlet weak var cominglbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // 출력할 데이터 parameter
    var param : String = "now_playing"
    
    //cell의 출력할 데이터를 저장하는 객체
    lazy var coreList : [NSManagedObject] = {
        return self.getMoviesWith(param)
    }()

    // "현재 상영중" 버튼 눌렀을 때 이벤트
    @IBAction func nowplaying(_ sender: Any) {
        param = "now_playing"
        //디자인 변경
        comingbtn.titleLabel?.textColor = UIColor.lightGray
        cominglbl.backgroundColor = UIColor.white
        playinglbl.backgroundColor = UIColor.black
        //"now_playing" 데이터만 가져오고 reloadData
        coreList = self.getMoviesWith(param)
        self.tableView.reloadData()
    }
    // "개봉예정" 버튼 눌렀을 때 이벤트
    @IBAction func upcoming(_ sender: Any) {
        param = "upcoming"
        //디자인 변경
        playingbtn.titleLabel?.textColor = UIColor.lightGray
        playinglbl.backgroundColor = UIColor.white
        let btn = sender as! UIButton
        cominglbl.backgroundColor = UIColor.black
        //"upcoming" 데이터만 가져오고 reloadData
        coreList = self.getMoviesWith(param)
        self.tableView.reloadData()
    }
    
    //server에서 영화 데이터를 가져와 CoreData에 저장하는 메소드
    func download(_ status : String){
        //데이터 요청 url
        let url = "https://api.themoviedb.org/3/movie/\(status)?api_key=0d18b9a2449f2b69a2489e88dd795d91&language=ko-KR&region=KR"
        
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
                    print("movies:\(movies.count)")
                    //페이지수 가져오기
                    let totalPages = jsonObject["total_pages"] as! Int
                    //coredata에 저장
                    for movieDic in movies{
                        self.save(movieDic, status)
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
    
    //CoreData에 목록 데이터 저장
    func save(_ movieDic : NSDictionary, _ status : String){
        //context 가져오기
        let context = self.appDelegate.persistentContainer.viewContext
        //데이터 삽입하는 객체
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context) as! MoviesMO
        //데이터 넣기
        newData.movieId = movieDic["id"] as! Int32
        newData.voteAverage = movieDic["vote_average"] as! Double
        newData.title = movieDic["title"] as! String
        
        newData.releaseDate = (movieDic["release_date"] as! NSString) as String
        newData.status = status
        
        // 이미지를 Data 타입으로 저장
        if (movieDic["poster_path"] as? NSString) != nil{
            let posterPath = (movieDic["poster_path"] as! NSString) as String
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            newData.posterData = try! Data(contentsOf: url!)
        }else{
            let noposter = UIImage(named: "noposter.png")
            newData.posterData = noposter?.pngData()
        }
        //commit or rollback
        do{
            try context.save()
        }catch{
            context.rollback()
            fatalError("\(title)저장 실패")
        }
    }
    
    //CoreData에서 조건에 맞는 데이터 찾아오기
    func getMoviesWith(_ status : String) -> [NSManagedObject]{
        //context 가져오기
        let context = self.appDelegate.persistentContainer.viewContext
        //Board Entity에서 데이터 가져오는 객체 - 요청 객체 가져오기
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Movies")
        //조건 설정
        fetchRequest.predicate = NSPredicate(format: "status==%@", status)
        //정렬
        let releaseDateDesc = NSSortDescriptor(key: "releaseDate", ascending: false)
        fetchRequest.sortDescriptors = [releaseDateDesc]
        do {
            let result = try context.fetch(fetchRequest)
            return result as! [NSManagedObject]
        } catch {
            fatalError("데이터 가져오기 실패");
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //데이터 다운로드 - 인터넷 사용 가능할 때
        self.download("now_playing")
        self.download("upcoming")
        tableView.delegate = self
        tableView.dataSource = self
        self.tabBarController?.title = "영화정보"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowplaying(playingbtn)
    }

}
extension MovieListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("corelist:\(coreList.count)")
        return coreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        //각 행에 출력할 데이터 가져오기
        let movieData = coreList[indexPath.row]
        //coreData에 저장된 데이터 가져오기
        cell.poster.image = UIImage(data: movieData.value(forKey: "posterData") as! Data)
        cell.title.text = movieData.value(forKey: "title") as? String
        //제목 텍스트 크기 설정 
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
