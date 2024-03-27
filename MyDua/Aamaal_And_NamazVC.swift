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
    
    var aamaalLanguage: String!
    var currentTimeZone: String!
    var currentDate: String!
    var arrLang = ["عربي","English","हिंदी","ગુજરાતી"]
    var pickerIsOn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchURLsupportData()
        UIApplication.shared.isIdleTimerDisabled = true
        performSupportURL()
        modeCheck()
        pickerviewModifi()
        let language = UserDefaults.standard.string(forKey: "GlobalStrLang")
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
        let url = URL(string: "https://mydua.online/amaal-namaz-app-page/?dd=\(currentDate!)&tz=\(currentTimeZone!)&lang=\(aamaalLanguage!)")!
        //let url = URL(string: "https://mydua.online/aamaal-and-namaz/")!
        webView.load(URLRequest(url: url))
    }
    
    
    func fetchURLsupportData(){
        
        let timeZone = TimeZone.current
        currentTimeZone = timeZone.identifier
     
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = dateFormatter.string(from: date)
        currentDate = String(formattedDate)
        
        
        let language = UserDefaults.standard.string(forKey: "GlobalStrLang")
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
