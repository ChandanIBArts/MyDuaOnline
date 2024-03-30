//
//  AamaalandNamazSingleTonAPI.swift
//  MyDua
//
//  Created by IB Arts Mac on 30/03/24.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class AamaalNamazSingleTonAPI {
    
   
    
    //MARK: Aamaal and Namaz API Call
    
    func AamaalNamazApi(date: String!, timeZone: String!, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock:((String?) -> Void)!){
        
        let apiURL = "https://mydua.online/wp-json/customapi/v1/aamaal-namaz?dd=\(date ?? "0")&tz=\(timeZone ?? "Asia/kolkata")"
        let token = "MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk="
       
        
        var request = URLRequest(url: URL(string: apiURL)!, timeoutInterval: Double.infinity)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            
            
            print(json["arabic"][0]["pdf_content"][0]["audio_file"]["title"])
            
            print(json["arabic"][0]["pdf_content"][1]["pdf_content"])
            
            successBlock(json)
        }
        task.resume()
        
    }
    
    
}
