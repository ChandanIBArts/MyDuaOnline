//
//  MyFavouritesVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON
import SDWebImage

/*
class MyFavouritesVC: UIViewController {
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    @IBOutlet weak var favourites: UITabBarItem!{
        didSet{
            favourites.image = UIImage(named: "favourite")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    @IBOutlet weak var floatingLbl: MarqueeLabel!
    @IBOutlet weak var lblHijri: UILabel!
    @IBOutlet weak var ViewContener: UIView!

    var shareds = MusicPlay.shared
    var floatLabelList : [JSON] = []
    let favouriteListCellHeight = 120
    let objSingleton = SingletonApi()
    var favouriteList = [ListOfFavourite]()
    var searchArr = [ListOfFavourite]()
    var searching : Bool?
    var indx: Int = 0
    var updateDay: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        fetchFavouritesData()
        setupUI()
        //startMarqueeAnimation()
        //floatingLabel ()
        hijriApiChangeDate()
        favouriteCollectionView.dataSource = self
        favouriteCollectionView.delegate = self
//        notificationCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hijriApiChangeDate()
        navigationController?.setNavigationBarHidden(true, animated: true)
        modeCheck()
        collectionViewcell()
        
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == nil {
            // Your code when the child view controller is being removed
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        shareds.player?.pause()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
            lblHijri.backgroundColor = .black
          //  favouriteTableView.reloadData()
        } else {
            overrideUserInterfaceStyle = .light
            lblHijri.backgroundColor = .white
           // favouriteTableView.reloadData()
        }
    }
    
    
    func hijriApi(day: Int){
        let objSingleton = SingletonApi()
        objSingleton.hijriTimeZoneChange(day: day, onSuccess: { response in
            
            print(response)
            DispatchQueue.main.async {
                let hijriText = response["hijri_date"].stringValue
                var testText = response["event"].stringValue
                var eventColor = response["event_color"].stringValue
   
                if testText == "" {
                    testText = testText
                } else {
                    testText = "(\(testText))"
                }
                //MARK: make attributedString
                var attributedString = NSMutableAttributedString(string: "\(hijriText) \n \(testText)")
                let range = NSString(string: "\(hijriText) \n \(testText)").range(of: "\(testText)", options: String.CompareOptions.caseInsensitive)
                
                let changeColor = self.hexStringToUIColor(hex: eventColor)
                
                //attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: range)
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: changeColor], range: range)
                self.lblHijri.attributedText = attributedString
            }
            
        }, onError: { message in
            print(message as Any)
        })
    }
    
    func floatingLabel () {
        objSingleton.floatLabelAPI(onSuccess: { response in
            print(response)
            DispatchQueue.main.async {
               self.floatLabelList = response["message"]["animatedtext"].arrayValue
                //self.floatingLbl.text = response["message"]["animatedtext"][0]["heading"].stringValue
                var strFinalVal = ""
               // print(self.floatLabelList)
                var removeWord = "</b>"
                for element in self.floatLabelList {
                    print(element)
                    
                    strFinalVal = strFinalVal + "  " + element["heading"].stringValue
                }
                var finalString = ""
                let remove_Word = ["</b>","</b>","<b>","</b>","<b>","</b>","<b>","</b>"]
                
                var firstString = strFinalVal.replacingOccurrences(of: "<b>Imam", with: " Imam", options: .regularExpression, range: nil)
                firstString = firstString.replacingOccurrences(of: "<b>Haji", with: " Haji", options: .regularExpression, range: nil)
               
                var stringArray  = firstString.components(separatedBy: " ")
                stringArray = stringArray.filter { !remove_Word.contains($0) }
                finalString = stringArray.joined(separator: " ")
                self.floatingLbl.text = finalString
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    
    func setupUI() {
        UIView.animate(withDuration: 10, delay: 0.01, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            var marqueeStyle = DefaultStyle()
           // marqueeStyle.backColor = .lightGray
            marqueeStyle.showFullText = true
            self.floatingLbl.style  = marqueeStyle
            self.floatingLbl.textColor = .white
            self.floatingLbl.font = .preferredFont(forTextStyle: .title1)
            self.floatingLbl.text =  DailyDuaVC.globalFloatinglable
        }, completion:  { _ in
            
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchFavouritesData(){
        self.objSingleton.favourite_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.favouriteList.append(contentsOf: response)
              //  self.favouriteTableView.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
}

extension MyFavouritesVC {
    func collectionViewcell(){
        let cellwidth = 150
        let cellHeight = 120
        let myLayout = UICollectionViewFlowLayout()
        myLayout.scrollDirection = .horizontal
        myLayout.itemSize = CGSize(width: cellwidth, height: cellHeight)
        myLayout.minimumInteritemSpacing = 5
        myLayout.minimumLineSpacing = 5
        favouriteCollectionView.collectionViewLayout = myLayout
    }

}

extension MyFavouritesVC: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favouriteCollectionView.dequeueReusableCell(withReuseIdentifier: "NewFavCVC", for: indexPath) as! NewFavCVC
        
        if traitCollection.userInterfaceStyle == .dark{
            cell.backView.layer.borderColor = UIColor.white.cgColor
        }else{
            cell.backView.layer.borderColor = UIColor.black.cgColor
        }
        
        if indexPath.row == 0 {
            
            cell.lblFav.text = "Listen your favorite Dua"
            
            cell.imgFav.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/Duaa-Supplication-in-Islam-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else if indexPath.row == 1 {
            
            cell.lblFav.text = "Listen your favorite Sahifa Sajjadia"
            
            cell.imgFav.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/Ziyarat-Ashura-AbdulHai-mp3-image-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else if indexPath.row == 2 {
            
            cell.lblFav.text = "Listen your favorite Ziyarat"
            
            cell.imgFav.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/leftimg-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else if indexPath.row == 3 {
            
            cell.lblFav.text = "Listen your favorite Surah"
            
            cell.imgFav.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/mostafa-meraji-engIodACYWw-unsplash-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else if indexPath.row == 4 {
            
            cell.lblFav.text = "Listen your All favorite"
            
            cell.imgFav.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/mohamed-nohassi-aDTMGRdx28w-unsplash-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        } else {
            
            print("Error")
            
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indx = indexPath.row
       
        let token = UserDefaults.standard.integer(forKey: "UserID")
        if token >= 1 {
        
            if indexPath.row == 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteDuaVC") as! FavouriteDuaVC
                
                self.ViewContener.frame = vc.view.bounds
                vc.arrFavList.removeAll()
                NotificationCenter.default.post(name:NSNotification.Name("sendValue"), object: nil, userInfo: ["strStatus":"Listen your favorite Dua"])
                self.ViewContener.addSubview(vc.view)
                self.addChild(vc)
                vc.didMove(toParent: self)
                vc.willMove(toParent: self)
                collectionView.reloadData()
               
            } else if indexPath.row == 1 {
                
               
                let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "MyFavouriteDetailsVC") as! FavouriteDuaVC
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SahifaSajjadiaFavVC") as! SahifaSajjadiaFavVC
               
                
                vc.vc1 = vc1
                if playingMusic == true{
                    vc1.player?.pause()
                    vc1.player = nil
                }
                else{
                    print("not playing")
                }
                
                self.ViewContener.frame = vc.view.bounds
                vc.arrFavList.removeAll()
                NotificationCenter.default.post(name:NSNotification.Name("sendValue"), object: nil, userInfo: ["strStatus":"Listen your favorite Sahifa Sajjadia"])
                
                self.ViewContener.addSubview(vc.view)
                self.addChild(vc)
                vc.didMove(toParent: self)
                vc.willMove(toParent: self)
                collectionView.reloadData()
            
            
            } else if indexPath.row == 2 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ZiyaratFavVC") as! ZiyaratFavVC
//                self.addChild(vc)
                self.ViewContener.frame = vc.view.bounds
                vc.arrFavList.removeAll()
               
                
                NotificationCenter.default.post(name:NSNotification.Name("sendValue"), object: nil, userInfo: ["strStatus":"Listen your favorite Ziyarat"])
                self.ViewContener.addSubview(vc.view)
                self.addChild(vc)
                vc.didMove(toParent: self)
                vc.willMove(toParent: self)
                collectionView.reloadData()
                
            } else if indexPath.row == 3 {
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SurahFavVC") as! SurahFavVC
//                self.addChild(vc)
                self.ViewContener.frame = vc.view.bounds
                vc.arrFavList.removeAll()
                NotificationCenter.default.post(name:NSNotification.Name("sendValue"), object: nil, userInfo: ["strStatus":"Listen your favorite Surah"])
                self.ViewContener.addSubview(vc.view)
                self.addChild(vc)
                vc.didMove(toParent: self)
                vc.willMove(toParent: self)
                collectionView.reloadData()
                
            } else if indexPath.row == 4 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllFavVC") as! AllFavVC
                self.addChild(vc)
                self.ViewContener.frame = vc.view.bounds
                vc.arrFavList.removeAll()
                NotificationCenter.default.post(name: NSNotification.Name("sendValue"), object: nil, userInfo: ["strStatus":"Listen your All favorite"])
                self.ViewContener.addSubview(vc.view)
                collectionView.reloadData()
            } 
            
        } else {
        
        let alert = UIAlertController(title: AppName, message: "Please login", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
        let signInStoryboard = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(signInStoryboard, animated: true)
        })
        alert.addAction(ok)
        present(alert, animated: true)
        
        }
        

    }
}
extension MyFavouritesVC {
    
    func hijriApiChangeDate(){
        updateDay = UserDefaults.standard.integer(forKey: "UpdateDate")
        if updateDay == nil || updateDay == 0 {
            
            hijriApi(day: 0)
            
        } else {
            
            hijriApi(day: updateDay!)
            
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
*/
