//
//  Aamaal_And_NamazVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 20/02/24.
//

import UIKit
import WebKit

class Aamaal_And_NamazVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var languageChangeBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var hijriLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var aamaalLanguage: String!
    var currentTimeZone: String!
    var currentDate: String!
    var arrLang = ["English", "ગુજરાતી", "हिंदी", "عربي"]  //["عربي","English","हिंदी","ગુજરાતી"]
    var pickerIsOn = false
    var updateDay: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        spinner.isHidden = false
        changeDate()
        fetchURLsupportData()
        UIApplication.shared.isIdleTimerDisabled = true
        performSupportURL()
        modeCheck()
        pickerviewModifi()
        var language = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if language == nil {
            language = "عربي"
        }
        languageChangeBtn.setTitle("  \(language!)", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    

    @IBAction func btnTapBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func btnTapLanguageChange(_ sender: UIButton) {
        
       // let language = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if pickerIsOn == false {
            pickerView.isHidden = false
            pickerIsOn = true
        } else {
            pickerView.isHidden = true
            pickerIsOn = false
        }
        
        
    }
    
    
    func pickerviewModifi(){
        pickerView.backgroundColor = .systemGreen
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        
    }
    

    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

    
    private func performSupportURL(){
        
//        let url = URL(string: "https://mydua.online/amaal-namaz-app-page/?dd=\(currentDate ?? "0")&tz=\(currentTimeZone ?? "Asia/Kolkatta")&lang=\(aamaalLanguage ?? "arabic")")!
//        webView.load(URLRequest(url: url))
        
        var request = URLRequest(url: URL(string: "https://mydua.online/amaal-namaz-app-page/?dd=\(currentDate ?? "0")&tz=\(currentTimeZone ?? "Asia/Kolkatta")&lang=\(aamaalLanguage ?? "arabic")")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            
            //webView.load(URLRequest(url: url))
            DispatchQueue.main.async {
                self.webView.loadHTMLString(String(data: data, encoding: .utf8)!, baseURL: nil)
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }

        task.resume()

      
        
    }
    
    
    func fetchURLsupportData(){
        
        
        currentDate = UserDefaults.standard.string(forKey: "UpdateDate")
        
        let timeZone = TimeZone.current
        currentTimeZone = timeZone.identifier

        let language = UserDefaults.standard.string(forKey: "GlobalStrLang")
        spinner.startAnimating()
        spinner.isHidden = false
        if language == "English" {
            aamaalLanguage = "english"
        } else if language == "हिंदी" {
            aamaalLanguage = "hindi"
        } else if language == "ગુજરાતી" {
            aamaalLanguage = "gujrati"
        } else {
            aamaalLanguage = "arabic"
        }
 
    }
    
    
    func changeDate(){
        updateDay = UserDefaults.standard.integer(forKey: "UpdateDate")
        if updateDay == nil || updateDay == 0 {
            
            setTimeZone(day: 0)
            
        } else {
            setTimeZone(day: updateDay!)
        }
        
    }
    
    func setTimeZone(day: Int){
        
        let objSingleton = SingletonApi()
        objSingleton.hijriTimeZoneChange(day: day, onSuccess: { response in
            
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
                
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: changeColor], range: range)
                self.hijriLbl.attributedText = attributedString
                
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
    
}
extension Aamaal_And_NamazVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrLang.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLang[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let setLang = arrLang[row]
        languageChangeBtn.setTitle("  \(setLang)", for: .normal)
        UserDefaults.standard.set(setLang, forKey: "GlobalStrLang")
        fetchURLsupportData()
        performSupportURL()
        pickerView.isHidden = true
        pickerIsOn = false
    }
    
}

