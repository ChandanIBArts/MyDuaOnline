//
//  SingletonAPI.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class SingletonApi: NSObject {
    //MARK: - Daily Dua API
    func dailyDuaListAPI( onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: baseAPIUrl + "dailydua?day=wednesday")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            // api
            let json = JSON(data)
            print(json)
            
            successBlock(json)
            
        }
        
        task.resume()
        
    }
    
    //MARK: - Dua API
    func dua_List_API( onSuccess successBlock: ((ListOfDua) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: baseAPIUrl + "dualist")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do{
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                let decode = try JSONDecoder().decode(ListOfDua.self, from: data)
                    successBlock(decode)
                    print(decode)
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }

    
    //MARK: - Ziyarat API
    func ziyarat_List_API( onSuccess successBlock: ((ListOfZiyarat) -> Void)!, onError errorBlock: ((String?) -> Void)!) {
        
        var request = URLRequest(url: URL(string: baseAPIUrl + "ziyaratlist")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                let decode = try JSONDecoder().decode(ListOfZiyarat.self, from: data)
                successBlock(decode)
                print(decode)
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    //MARK: - Surah API
//    func surahListAPI( onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
//        
//        var request = URLRequest(url: URL(string: baseAPIUrl + "surahlist")!,timeoutInterval: Double.infinity)
//        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
//        
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                return
//            }
//            print(String(data: data, encoding: .utf8)!)
//            // api
//            let json = JSON(data)
//            print(json)
//            
//            successBlock(json)
//            
//        }
//        
//        task.resume()
//        
//    }
//    
    
    func surah_List_API( onSuccess successBlock: ((ListOfSurah) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: baseAPIUrl + "surahlist")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do{
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                let decode = try JSONDecoder().decode(ListOfSurah.self, from: data)
                successBlock(decode)
                print(decode)
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    //MARK: - Favourites API
    func favourite_List_API( onSuccess successBlock: (([ListOfFavourite]) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: baseAPIUrl + "allfavourite?userid=1")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do{
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                let decode = try JSONDecoder().decode([ListOfFavourite].self, from: data)
                successBlock(decode)
                print(decode)
            } catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
}


