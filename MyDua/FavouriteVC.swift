//
//  FavouriteVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 21/03/24.
//

import UIKit
import SwiftyJSON
import SDWebImage

class FavouriteVC: UIViewController {
    
    @IBOutlet weak var floatingLbl: MarqueeLabel!
    @IBOutlet weak var lblHijri: UILabel!
    @IBOutlet weak var favouriteTableview: UITableView!
    
    var floatLabelList : [JSON] = []
    let objSingleton = SingletonApi()

    var updateDay: Int?
    
    var favouriteList = [ListOfFavourite]()
    var searching : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavouritesData()
        setupUI()
        favouriteTableview.dataSource = self
        favouriteTableview.delegate = self
        favouriteTableview.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hijriApiChangeDate()
        modeCheck()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    
    @IBAction func btnTapBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    

}
extension FavouriteVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTVCell", for: indexPath) as! FavouriteTVCell
    
        if traitCollection.userInterfaceStyle == .dark{
            cell.cellView.layer.borderColor = UIColor.white.cgColor
            cell.cellView.layer.borderWidth = 2
        }else{
            cell.cellView.layer.borderColor = UIColor.black.cgColor
            cell.cellView.layer.borderWidth = 2
        }
        
        if indexPath.row == 0 {
            
            cell.lblFavouriteTitle.text = "Listen your favorite Dua"
            cell.imgView.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/Duaa-Supplication-in-Islam-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else if indexPath.row == 1 {
            
            cell.lblFavouriteTitle.text = "Listen your favorite Sahifa Sajjadia"
            cell.imgView.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/Ziyarat-Ashura-AbdulHai-mp3-image-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else if indexPath.row == 2 {
            
            cell.lblFavouriteTitle.text = "Listen your favorite Ziyarat"
            cell.imgView.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/leftimg-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else if indexPath.row == 3 {
            
            cell.lblFavouriteTitle.text = "Listen your favorite Surah"
            cell.imgView.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/mostafa-meraji-engIodACYWw-unsplash-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        else {
            
            cell.lblFavouriteTitle.text = "Listen your All favorite"
            cell.imgView.sd_setImage(with: URL(string: "https://mydua.online/wp-content/uploads/2023/10/mohamed-nohassi-aDTMGRdx28w-unsplash-150x150.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "DetailsFabVC") as! DetailsFabVC
        
        if indexPath.row == 0{
            storyboard.storyboardTitle = "Listen your favorite Dua"
        } else if indexPath.row == 1 {
            storyboard.storyboardTitle = "Listen your favorite Sahifa Sajjadia"
            
        } else if indexPath.row == 2 {
            storyboard.storyboardTitle = "Listen your favorite Ziyarat"
            
        } else if indexPath.row == 3 {
            storyboard.storyboardTitle = "Listen your favorite Surah"
            
        } else {
            storyboard.storyboardTitle = "Listen your All favorite"
            
        }
        
        self.navigationController?.pushViewController(storyboard, animated: true)
            
       
        
        /*
        else if indexPath.row == 1 {
            
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "SahifaSajjadiaFavVC") as! SahifaSajjadiaFavVC
            self.navigationController?.pushViewController(storyboard, animated: true)
            
        } else if indexPath.row == 2 {
            
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteDuaVC") as! FavouriteDuaVC
            self.navigationController?.pushViewController(storyboard, animated: true)
            
        } else if indexPath.row == 3 {
            
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteDuaVC") as! FavouriteDuaVC
            self.navigationController?.pushViewController(storyboard, animated: true)
            
        } else {
            
            
        }
        
        */
    }
    
    
}

extension FavouriteVC {
    
    
    func fetchFavouritesData(){
        self.objSingleton.favourite_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.favouriteList.append(contentsOf: response)
                self.favouriteTableview.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })
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
    
    func hijriApiChangeDate(){
        updateDay = UserDefaults.standard.integer(forKey: "UpdateDate")
        if updateDay == nil || updateDay == 0 {
            
            hijriApi(day: 0)
            
        } else {
            
            hijriApi(day: updateDay!)
            
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
}
