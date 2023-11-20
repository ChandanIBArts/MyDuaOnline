//
//  SafhiaSajjadiaVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 20/11/23.
//

import UIKit

class SafhiaSajjadiaVC: UIViewController {
    @IBOutlet weak var safhiaTableView: UITableView!
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
        objSingleton.sahfia_sajjadia_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.duaList.append(contentsOf: response.english_dua ?? [])
                self.safhiaTableView.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
}

//MARK: - TableView & SearchBar Methods
extension SafhiaSajjadiaVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false) {
            return searchArr.count
        } else {
            return duaList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = safhiaTableView.dequeueReusableCell(withIdentifier: "SahifaSajjadiaTableViewCell", for: indexPath) as? SahifaSajjadiaTableViewCell {
            
            if (!(searching ?? false)) {
                let arr = duaList[indexPath.row]
                cell.sahifaTitleLbl.text = arr.name ?? ""
                cell.audioUrl = arr.file ?? ""
            } else {
                let searchArr = searchArr[indexPath.row]
                cell.sahifaTitleLbl.text = searchArr.name ?? ""
                cell.audioUrl = searchArr.file ?? ""
            }
            cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = storyboard?.instantiateViewController(withIdentifier: "AudioDetailVC") as? AudioDetailVC {
            self.navigationController?.pushViewController(cell, animated: true)
            
            if (!(searching ?? false)) {
                let arr = duaList[indexPath.row]
                cell.audioLbl = arr.name ?? ""
                cell.audioUrl = arr.file ?? ""
            } else {
                let searchArr = searchArr[indexPath.row]
                cell.audioLbl = searchArr.name ?? ""
                cell.audioUrl = searchArr.file ?? ""
            }
        }
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
        safhiaTableView.reloadData()
        
    }
}

