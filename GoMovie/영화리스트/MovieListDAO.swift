//
//  MovieListDAO.swift
//  GoMovie
//
//  Created by 503-03 on 06/12/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
import CoreData

class MovieListDAO {
    //AppDelegate 객체에 대한 참조 변수
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    //context 가져오기
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //CoreData에 영화목록 데이터 저장
    func save(_ movieDic : NSDictionary, _ status : String){
        
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
            print("저장 실패")
        }
    }
    
    
    //CoreData에서 조건에 맞는 데이터 찾아오기
    func getMoviesWith(_ status : String, ascending: Bool) -> [NSManagedObject]{
        
        //Board Entity에서 데이터 가져오는 객체 - 요청 객체 가져오기
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Movies")
        //조건 설정
        fetchRequest.predicate = NSPredicate(format: "status==%@", status)
        //정렬
        let releaseDateDesc = NSSortDescriptor(key: "releaseDate", ascending: ascending)
        fetchRequest.sortDescriptors = [releaseDateDesc]
        do {
            let result = try context.fetch(fetchRequest)
            return result as! [NSManagedObject]
        } catch {
            fatalError("데이터 가져오기 실패");
        }
        
    }
    
    //삭제
    func deleteAll() -> Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Movies")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try context.execute(deleteRequest)
            try context.save()
            return true
        }catch{
            context.rollback()
            print("데이터 삭제 실패")
            return false
        }
    }

}
