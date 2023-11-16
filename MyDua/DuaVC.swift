//
//  DuaVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON

class DuaVC: UIViewController {
    
    @IBOutlet weak var duaTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let duaListCellHeight = 90.0
    var duaList = [English_dua]()
    var searchArr = [English_dua]()
    let objSingleton = SingletonApi()
    var searching: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Dua API Call
        fetchDuaList()
    }
    
    func fetchDuaList() {
        objSingleton.dua_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.duaList.append(contentsOf: response.english_dua ?? [])
                self.duaTableView.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
}

//MARK: - TableView & SearchBar Methods
extension DuaVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false) {
            return searchArr.count
        } else {
            return duaList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = duaTableView.dequeueReusableCell(withIdentifier: "DuaTableViewCell", for: indexPath) as? DuaTableViewCell {
            
            if (!(searching ?? false)) {
                let arr = duaList[indexPath.row]
                cell.duaTitleLbl.text = arr.name ?? ""
                cell.audioUrl = arr.file ?? ""
            } else {
                let searchArr = searchArr[indexPath.row]
                cell.duaTitleLbl.text = searchArr.name ?? ""
                cell.audioUrl = searchArr.file ?? ""
            }
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return duaListCellHeight
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            searchArr = duaList
        } else {
            searchArr = duaList.filter{$0.name!.contains(searchText.capitalized)}
        }
        searching = true
        duaTableView.reloadData()
        
    }
}

