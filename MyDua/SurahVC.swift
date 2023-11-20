//
//  SurahVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON

class SurahVC: UIViewController {
    @IBOutlet weak var surahTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var surah: UITabBarItem! {
        didSet{
            surah.image = UIImage(named: "surah")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }

    
    let surahListCellHeight = 90.0
    let objSingleton = SingletonApi()
    
    var surahList = [Arabic_surah]()
    var searchArr = [Arabic_surah]()
    var searching : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSurahData()
    }
    
    func fetchSurahData(){
        self.objSingleton.surah_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.surahList.append(contentsOf: response.arabic_surah ?? [])
                self.surahTableView.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
}

//MARK: - TableView Methods
extension SurahVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false) {
            return searchArr.count
        } else {
            return surahList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = surahTableView.dequeueReusableCell(withIdentifier: "SurahTableViewCell", for: indexPath) as? SurahTableViewCell {
            
            if (!(searching ?? false)) {
                let arr  = surahList[indexPath.row]
                cell.surahTitleLbl.text = arr.name ?? ""
                cell.audioUrl = arr.file ?? ""
            } else {
                let searchArr = searchArr[indexPath.row]
                cell.surahTitleLbl.text = searchArr.name ?? ""
                cell.audioUrl = searchArr.file ?? ""
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return surahListCellHeight
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            searchArr = surahList
        } else {
            searchArr = surahList.filter{$0.name!.contains(searchText.capitalized)}
        }
        searching = true
        surahTableView.reloadData()
        
    }
}
