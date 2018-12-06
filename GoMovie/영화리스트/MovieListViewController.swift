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
    
    // 출력할 데이터 parameter
    var param : String = "now_playing"
    
    //cell의 출력할 데이터를 저장하는 객체
    lazy var coreList : [NSManagedObject] = {
        return self.getMoviesWith(param)
    }()
    @IBOutlet weak var playinglbl: UILabel!
    @IBOutlet weak var cominglbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func nowplaying(_ sender: Any) {
        param = "now_playing"
        //let btn = sender as! UIButton
        //btn.titleColor(for: .selected)
        //playinglbl.backgroundColor
        self.tabBarController?.title = "현재 상영중"
        //"now_playing" 데이터만 가져오기
        coreList = self.getMoviesWith(param)
        self.tableView.reloadData()
    }
    
    @IBAction func upcoming(_ sender: Any) {
        param = "upcoming"
        self.tabBarController?.title = "개봉예정"
        coreList = self.getMoviesWith(param)
        self.tableView.reloadData()
    }

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
    //CoreData에 목록 데이터 저장
    func save(_ movieDic : NSDictionary, _ status : String){
        //context 가져오기
        let context = self.appDelegate.persistentContainer.viewContext
        //데이터 삽입하는 객체
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context) as! MoviesMO
        //데이터 넣기
        newData.movieId = movieDic["id"] as! Int32
        newData.voteAverage = movieDic["vote_average"] as! Double
        newData.title = (movieDic["title"] as! NSString) as String

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
        
        
        do{
            try context.save()
        }catch{
            context.rollback()
            fatalError("\(title)저장 실패")
        }
    }
    //데이터를 다운로드 받는 메소드
    func download(_ status : String){
        //데이터 요청 url
        let url = "https://api.themoviedb.org/3/movie/\(status)?api_key=0d18b9a2449f2b69a2489e88dd795d91&language=ko-KR&region=KR"
        
        //서버에서 영화 목록 데이터 가져오기 - 인터넷 사용가능 할 때
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
                    //total 페이지 가져오기
                    let totalPages = jsonObject["total_pages"] as! Int
                    //coredata에 저장
                    for movieDic in movies{
                        self.save(movieDic, status)
                    }
                    self.tableView.reloadData()
                }else{
                    print("데이터 없음")
                }
            case.failure(let error):
                print("데이터 가져오기 실패:\(error)")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //데이터 다운로드 - 인터넷 사용 가능할 때
        self.download("now_playing")
        self.download("upcoming")
        coreList = getMoviesWith(param)
        self.tabBarController?.title = "현재 상영중"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

}
extension MovieListViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("corelist:\(coreList.count)")
        return coreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        //데이터 하나씩 가져오기
        let movieData = coreList[indexPath.row]
        
        cell.title.text = movieData.value(forKey: "title") as? String
        
        let voteAverage = movieData.value(forKey: "voteAverage") as! Double
        cell.voteAverage.text = "평점: \(String(format: "%.1f", voteAverage))"
        //비동기적으로 별image출력
        DispatchQueue.main.async {
            //if voteAverage != 0.0{
                RatingView.showInView(view: cell.ratingView, value: voteAverage/2)
//            }else{
//                RatingView.showNORating(view: cell.ratingView)
//            }
        }
        
        cell.releaseDate.text = movieData.value(forKey: "releaseDate") as? String
        cell.poster.image = UIImage(data: movieData.value(forKey: "posterData") as! Data)
    
        return cell
    }
    
    //cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 172
    }
    
    //cell를 선택했을 때 호출되는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        //선택한 movieId 찾아오기
        let movieData = self.coreList[indexPath.row]
        let movieId = movieData.value(forKey: "movieId") as! Int
        let posterData = movieData.value(forKey: "posterData") as! Data
        detailViewController.movie.append(["movieId": movieId])
        detailViewController.movie.append(["posterData": posterData])

        //print(detailViewController.linkUrl)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
