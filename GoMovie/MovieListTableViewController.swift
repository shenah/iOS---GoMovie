//
//  MovieListTableViewController.swift
//  GoMovie
//
//  Created by 503-03 on 21/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
class MovieListTableViewController: UITableViewController {
    
    //cell의 출력할 정보들을 가져오기
    var movies : [NSDictionary] = [NSDictionary]()
    
    //로그인 정보 AppDelegate 객체에 대한 참조 변수
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    func save(movieDic : NSDictionary) -> Bool{
        //정보 가져와서 CoreData에 저장
        let context = appDelegate.persistentContainer.viewContext
        //데이터 삽입하는 객체
        let newData = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context)
        //데이터 넣기
        let movieDic = movies[0]
        let movieId = movieDic["movieId"] as! Int16
        let voteAverage = movieDic["voteAverage"] as! Double
        let title = (movieDic["title"] as! NSString) as String
        let posterPath = "https://image.tmdb.org/t/p/w500\((movieDic["posterPath"] as! NSString) as String)"
        let backdropPath = "https://image.tmdb.org/t/p/w500\((movieDic["backdropPath"] as! NSString) as String)"
        let overview = (movieDic["overview"] as! NSString) as String
        let originalLanguage = (movieDic["originalLanguage"] as! NSString) as String
        let originalTitle = (movieDic["originalTitle"] as! NSString) as String
        let adult = (movieDic["adult"] as! NSString) as String
        let releaseDate = (movieDic["releaseDate"] as! NSString) as String
        let status = (movieDic["status"] as! NSString) as String
        
        newData.setValue(movieId, forKey: "movieId")
        newData.setValue(voteAverage, forKey: "voteAverage")
        newData.setValue(title, forKey: "title")
        newData.setValue(posterPath, forKey: "posterPath")
        newData.setValue(backdropPath, forKey: "backdropPath")
        newData.setValue(overview, forKey: "overview")
        newData.setValue(originalLanguage, forKey: "originalLanguage")
        newData.setValue(originalTitle, forKey: "originalTitle")
        newData.setValue(adult, forKey: "adult")
        newData.setValue(releaseDate, forKey: "releaseDate")
        newData.setValue(status, forKey: "status")
        do {
            try context.save()
            //self.list.append(object)
            // self.list.insert(object, at: 0)
            return true
        } catch {
            context.rollback()
            return false
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //로그인 정보 설정
        //print(appDelegate.id + appDelegate.nickname)
        if appDelegate.id != nil {
            self.tabBarController?.title = appDelegate.nickname + "님"
            let image = appDelegate.image
            //print(image!)
             //let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/images/\(image)", method:.get, parameters:nil)
            //request.responseJSON(completionHandler:)
        }else{
            self.title = "로그인"
        }
        
        //영화 목록 데이터 가져오기 - 인터넷 사용할 수 있을 때
        let request = Alamofire.request("http://192.168.0.113:8080/MobileServer/movie/now_playing", method: .get, parameters: ["status": "now_playing"], encoding: URLEncoding.default , headers: nil)
        request.responseJSON(completionHandler: {response in
            
            self.movies.append(contentsOf: response.result.value
                as! [NSDictionary])
            print(self.movies)
            //print(self.movies.count)
            self.title = "상영중"
            
            //Alamofire는 비동기적으로 데이터를 읽어 오기 때문에 데이터를 가져온 후 reload해야 함
            self.tableView.reloadData()
        })
        
//        for movieDic in movies{
//            save(movieDic: movieDic
//
//        }
        
        
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    //섹션의 개수를 설정하는 메소드
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

   //cell 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        

        //print(movies[indexPath.row])
        let movieDic = movies[indexPath.row]
        
        cell.title.text = (movieDic["title"] as! NSString) as String
        cell.voteAverage.text = "\(movieDic["voteAverage"]!)"
        cell.releseDate.text = (movieDic["releaseDate"] as! NSString) as String
        
        return cell
    }
    
    //cell 높이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 227
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

