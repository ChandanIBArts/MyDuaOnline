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

    //MARK: Token ID
    func submitTokenIDTimeZoneAPI(){

        let parameters = [
          [
            "key": "token",
            "value": UserDefaults.standard.value(forKey: "TokenID") ?? "",
            "type": "text"
          ],
          [
            "key": "timezone",
            "value": DailyDuaVC.timezone ?? "",
            "type": "text"
          ]] as [[String: Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] != nil { continue }
          let paramName = param["key"]!
          body += "--\(boundary)\r\n"
          body += "Content-Disposition:form-data; name=\"\(paramName)\""
          if param["contentType"] != nil {
            body += "\r\nContent-Type: \(param["contentType"] as! String)"
          }
          let paramType = param["type"] as! String
          if paramType == "text" {
            let paramValue = param["value"] as! String
            body += "\r\n\r\n\(paramValue)\r\n"
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/fcm-api/v1/save-token")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
    
    //MARK: - FAv Dua API
    func makeFavourite(userId:String,audioId:Int,typeOfAudio:String,compl:@escaping ((String)->Void)){
      //duafavaudio
        let strUrl = "https://mydua.online/wp-json/customapi/v1/\(typeOfAudio)?userid=\(userId)&audioid=\(audioId)"
       // let strUrl = "https://mydua.online/wp-json/customapi/v1/duafavaudio?userid=\(userId)&audioid=\(audioId)"
        let token = "Bearer MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk="
        guard let url = URL(string: strUrl) else{return}
        DispatchQueue.main.async {
            AF.request(url,method: .post,parameters: [:],encoding: JSONEncoding.default,headers: ["Authorization":token]).responseJSON { resp in
                switch resp.result{
                    
                case .success(_):
                    do{
                        guard let data = resp.data else{return}
                    let js = try JSON(data: data)
                        compl(js["type"].stringValue as? String ?? "")
                        //compl(js["fav"].stringValue as? String ?? "")
                        print(js)
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    
                }
            }

        }
    }
    
    
    // MARK: Add favourite & unfavourite Dua
    //https://mydua.online/wp-json/customapi/v1/duafavaudio?userid=52&audioid=447
    func addFavouriteAndUnfavouriteDua(userId: String, audioId: Int, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/duafavaudio?userid=\(userId)&audioid=\(audioId)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
        
    }
    
    // MARK: Add favourite & unfavourite Sahifa Sajjadia
    //https://mydua.online/wp-json/customapi/v1/sahifafavaudio?userid=52&audioid=1230
    func addFavouriteAndUnfavouriteSahifaSajjadia (userId: String, audioId: Int, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/sahifafavaudio?userid=\(userId)&audioid=\(audioId)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
        
    }
    
    // MARK: Add favourite & unfavourite Ziyarat
    //https://mydua.online/wp-json/customapi/v1/ziyaratfavaudio?userid=52&audioid=468
    func addFavouriteAndUnfavouriteZiyarat (userId: String, audioId: Int, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/ziyaratfavaudio?userid=\(userId)&audioid=\(audioId)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
        
    }
    
    // MARK: Add favourite & unfavourite Surah
    //https://mydua.online/wp-json/customapi/v1/surahfavaudio?userid=52&audioid=463
    func addFavouriteAndUnfavouriteSurah (userId: String, audioId: Int, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/surahfavaudio?userid=\(userId)&audioid=\(audioId)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
        
    } 
    
    
//    (userId: String, audioId: Int, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
//        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/ziyaratfavaudio?userid=\(userId)&audioid=\(audioId)")!,timeoutInterval: Double.infinity)
//        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "POST"
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//          guard let data = data else {
//            print(String(describing: error))
//            return
//          }
//          print(String(data: data, encoding: .utf8)!)
//            let json = JSON(data)
//            print(json)
//            successBlock(json)
//        }
//
//        task.resume()
//        
//    }
//    
    
    
    
    
    
    //MARK: - Daily Dua API
    func dailyDuaListAPI( onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
       
        if let day = UserDefaults.standard.value(forKey: "currentDay") {
            print(day)
           
            var request = URLRequest(url: URL(string: baseAPIUrl + "dailydua?day=\(day)")!,timeoutInterval: Double.infinity)
            
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
        
    }
    
    //MARK: - Dua API
    func dua_List_API( onSuccess successBlock: ((ListOfDua) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        //UserDefaults.standard.setValue(userId, forKey: "UserID")
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        print(userId)
        
        if userId.isEmpty{
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
        else{
            var request = URLRequest(url: URL(string: baseAPIUrl + "dualist?userid=\(userId)")!,timeoutInterval: Double.infinity)
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

        
    }
    
    //MARK: - Sahfia Sajjadia
    
    func sahfia_sajjadia_API( onSuccess successBlock: ((ListOfDua) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        if userId.isEmpty{
            var request = URLRequest(url: URL(string: baseAPIUrl + "sahifalist")!,timeoutInterval: Double.infinity)
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
        else{
            var request = URLRequest(url: URL(string: baseAPIUrl + "sahifalist?userid=\(userId)")!,timeoutInterval: Double.infinity)
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

        
    }
    
    
    //MARK: - Ziyarat API
    func ziyarat_List_API( onSuccess successBlock: ((ListOfZiyarat) -> Void)!, onError errorBlock: ((String?) -> Void)!) {
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        
        if userId.isEmpty{
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
        else{
            var request = URLRequest(url: URL(string: baseAPIUrl + "ziyaratlist?userid=\(userId)")!,timeoutInterval: Double.infinity)
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
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        if userId.isEmpty{
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
        else{
            var request = URLRequest(url: URL(string: baseAPIUrl + "surahlist?userid=\(userId)")!,timeoutInterval: Double.infinity)
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
    
    //MARK: - Floating label API
   
    
    func floatLabelAPI( onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string: baseAPIUrl + "themeoptions")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

        
    }
    
    func hijriLabelAPI( onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        //\(DailyDuaVC.timezone)
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/hijridateapi?tz=\(DailyDuaVC.timezone ?? "")")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
       
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

        
    }
    
    //MARK: Change Password label API
    
    func forgotPasswordAPI(email:String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/forget_password?email=\(email)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk=", forHTTPHeaderField: "Authorization")
       
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
        
    }
    
    //MARK: - Login label API
    func LoginApi(email:String,password:String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/login?username=\(email)&password=\(password)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk=", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }

            print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

        
    }
    //MARK: -SignUp label API
    func SignUpApi(username:String,firstname:String,lastname:String,email:String,password:String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        //var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/register?username=ankush1&password=Abcd%401234&email=ankushgoyal21701%40gmail.com&firstname=Ankush&lastname=Goyal")!,timeoutInterval: Double.infinity)

//        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/register?username=\(username),firstname=\(firstname),lastname=\(lastname),email=\(email),password=\(password)")!,timeoutInterval: Double.infinity)
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/register?username=\(username)&password=\(password)&email=\(email)&firstname=\(firstname)&lastname=\(lastname)")!,timeoutInterval: Double.infinity)

        request.addValue("Bearer MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk=", forHTTPHeaderField: "Authorization")
       
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
            
        }

        task.resume()

        
    }
    //MARK: - Changepass label API
    func ChangePasswordApi(userId:String,oldpassword:String,newpassword:String,changepassword:String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/changepassword?oldpassword=\(oldpassword)&newpassword=\(newpassword)&cnewpassword=\(changepassword)&userid=\(userId)")!,timeoutInterval: Double.infinity)
        
        //var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/changepassword?oldpassword=\(oldpassword)&newpassword=\(newpassword)&cnewpassword=\(changepassword)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk=", forHTTPHeaderField: "Authorization")
        

        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

    }
    
    
    
    
    //MARK: MyProfile API
    func MyProfileAPI(userId: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/userinfo?userid=\(userId)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
    }
    
    
    //MARK: Update Profile

    func UpdateProfile(userid: String, gender: String, phonr: String, firstname: String, lastname: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock:((String) -> Void)!) {
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/updateuserinfo?userid=\(userid)&gender=\(gender)&phone=\(phonr)&firstname=\(firstname)&lastname=\(lastname)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func favListApi(onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: baseAPIUrl + "page/348")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

    }
    
    func favDuaListDetailsAPI(userid: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        // https://mydua.online/wp-json/customapi/v1/favouritedua?userid=52
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/favouritedua?userid=\(userid)")!,timeoutInterval: Double.infinity)

        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
       
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

    }
    

    
    func favSahifaListDetailsAPI(userid: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/favouriteshifa?userid=\(userid)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

    }
    func favZiyaratListDetailsAPI(userid: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        //https://mydua.online/wp-json/customapi/v1/favouriteziyarat?userid=52
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/favouriteziyarat?userid=\(userid)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
       

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

    }
    
    func favSurahListDetailsAPI(userid: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        //https://mydua.online/wp-json/customapi/v1/favouritesurah?userid=52
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/favouritesurah?userid=\(userid)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

    }
   
    func favAllListDetailsAPI(userid: String,onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        var request = URLRequest(url: URL(string:"https://mydua.online/wp-json/customapi/v1/allfavourite?userid=\(userid)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
       
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

    }
    
    
    

    //MARK: list of fav dua
    func listOfFavDua(userid: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/allfavourite?userid=\(userid)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
       
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()
        
    }
    
    //MARK: Hijri Time Zone Change
    func hijriTimeZoneChange(day: Int, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock: ((String?) -> Void)!){
        
        //\(DailyDuaVC.timezone)
        
        var request = URLRequest(url: URL(string: "https://mydua.online/wp-json/customapi/v1/hijridateapi?tz=\(DailyDuaVC.timezone ?? "")&dd=\(day)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
       
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }

        task.resume()

        
    }
    
    
    //https://mydua.online/wp-json/customapi/v1/special-events?dd=0&tz=Asia/Kolkata
    //Event
    
    //MARK: Event API Call
    func eventAPIcall(day: Int, timeZone: String, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock:((String?) -> Void)!) {
        
        var request = URLRequest( url: URL(string: "https://mydua.online/wp-json/customapi/v1/special-events?dd=\(day)&tz=\(timeZone)")!, timeoutInterval: Double.infinity)
        
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }
        
        task.resume()
        
        
    }
    
    
    
    //https://mydua.online/wp-json/customapi/v1/prayertimes?lat=52.569500&long=-0.240530
    
    //MARK: Latitude & Longitude API Call
    func longLatAPIcall(lat: Double, lon: Double, onSuccess successBlock: ((JSON) -> Void)!, onError errorBlock:((String?) -> Void)!) {
        
        var request = URLRequest( url: URL(string: "https://mydua.online/wp-json/customapi/v1/prayertimes?lat=\(lat)&long=\(lon)")!, timeoutInterval: Double.infinity)
        
        request.addValue("Bearer \(tokenID)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let json = JSON(data)
            print(json)
            successBlock(json)
        }
        
        task.resume()
        
    }
    
}
