//
//  DailyDuaVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON
import AVFoundation

class DailyDuaVC: UIViewController {
    
    @IBOutlet weak var dailyDuaTableView: UITableView!
    let dailyDuaCellHeight = 90.0
    var englishDuaList : [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Daily Dua API Call
        let objSingleton = SingletonApi()
        objSingleton.dailyDuaListAPI(onSuccess: {response in
            print("Got Respose")
            print(response)
            print(response[0]["english_dua"].count)
            DispatchQueue.main.async {
                if response != nil {
                    self.englishDuaList = response[0]["english_dua"].arrayValue
                    print(self.englishDuaList)
                    self.dailyDuaTableView.reloadData()
                    
                } else {
                    AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
                }
            }
        }, onError: { message in
            print(message as Any)
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
}

//MARK: - TableView Methods
extension DailyDuaVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return englishDuaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = dailyDuaTableView.dequeueReusableCell(withIdentifier: "DailyDuaTableViewCell", for: indexPath) as? DailyDuaTableViewCell {
            
            cell.titleLbl.text = englishDuaList[indexPath.row]["audio"]["title"].stringValue
            
//            cell.audioFileNameLbl.text = englishDuaList[indexPath.row]["audio"]["filename"].stringValue
            
            cell.audioUrl = englishDuaList[indexPath.row]["audio"]["url"].stringValue
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dailyDuaCellHeight
    }
}


