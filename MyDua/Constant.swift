//
//  Constant.swift
//  MyDua
//
//  Created by IB Arts Mac on 09/11/23.
//

import Foundation

let baseAPIUrl = "https://mydua.online/wp-json/customapi/v1/"
let AppName = "My Dua"
//let tokenID = UserDefaults.standard.value(forKey: "TokenID") ?? "NewToken"
var tokenID = "MTAtMjAtMjAyMyAwOToyNDoyNkZ6VXI1MURKRGJZZ3dodVk="
var userID = ""
var strLoginName = UserDefaults.standard.value(forKey: "LoginUser")
var globalSpeed:Float = 1.0
var globalControlerName = ""

var fajrTm: String?
var sunriseTm: String?
var dhuhrTm: String?
var sunsetTm: String?
var maghribTm: String?


func saveAudioToPhone(url:String){
    if let audioUrl = URL(string: url) {

        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
        print(destinationUrl)

        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")

            // if the file doesn't exist
        } else {

            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    print("File moved to documents folder")
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
    
}
