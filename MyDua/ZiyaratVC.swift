//
//  ZiyaratVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON

class ZiyaratVC: UIViewController {

    @IBOutlet weak var ziyaratTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let ziyaratListCellHeight = 90.0
    let objSingleton = SingletonApi()

    var ziyaratList = [Arabic_ziyarat]()
    var searchArr = [Arabic_ziyarat]()
    var searching: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        // ZiyaratList API Call
        fetchZiyaratData()
    }
    
    func fetchZiyaratData() {
        objSingleton.ziyarat_List_API(onSuccess: {response in
            DispatchQueue.main.async {
                self.ziyaratList.append(contentsOf: response.arabic_ziyarat ?? [])
                self.ziyaratTableView.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
}

//MARK: - TableView Methods
extension ZiyaratVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false) {
            return searchArr.count
        } else {
            return ziyaratList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = ziyaratTableView.dequeueReusableCell(withIdentifier: "ZiyaratTableViewCell", for: indexPath) as? ZiyaratTableViewCell {
           
            if (!(searching ?? false)) {
                let arr = ziyaratList[indexPath.row]
                cell.ziyaratTitleLbl.text = arr.name ?? ""
                cell.audioUrl = arr.file ?? ""
            } else {
                let searchArr = searchArr[indexPath.row]
                cell.ziyaratTitleLbl.text = searchArr.name ?? ""
                cell.audioUrl = searchArr.file ?? ""
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ziyaratListCellHeight
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            searchArr = ziyaratList
        } else {
            searchArr = ziyaratList.filter{$0.name!.contains(searchText.capitalized)}
        }
        searching = true
        ziyaratTableView.reloadData()
        
    }
}
