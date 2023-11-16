//
//  MyFavouritesVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit

class MyFavouritesVC: UIViewController {

    @IBOutlet weak var favouriteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favourites: UITabBarItem!{
        didSet{
            favourites.image = UIImage(named: "favourite")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    
    let favouriteListCellHeight = 90.0
    let objSingleton = SingletonApi()
    
    var favouriteList = [ListOfFavourite]()
    var searchArr = [ListOfFavourite]()
    var searching : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavouritesData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchFavouritesData(){
        self.objSingleton.favourite_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.favouriteList.append(contentsOf: response)
                self.favouriteTableView.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
}

//MARK: - TableView Methods
extension MyFavouritesVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false) {
            return searchArr.count
        } else {
            return favouriteList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = favouriteTableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as? FavouriteTableViewCell {
            
            if (!(searching ?? false)) {
                let arr  = favouriteList[indexPath.row]
                cell.favouriteTitleLbl.text = arr.name ?? ""
                cell.audioUrl = arr.file ?? ""
            } else {
                let searchArr = searchArr[indexPath.row]
                cell.favouriteTitleLbl.text = searchArr.name ?? ""
                cell.audioUrl = searchArr.file ?? ""
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return favouriteListCellHeight
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            searchArr = favouriteList
        } else {
            searchArr = favouriteList.filter{$0.name!.contains(searchText.capitalized)}
        }
        searching = true
        favouriteTableView.reloadData()
        
    }
}
