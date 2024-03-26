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
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    var aamaalLanguage: String!
    var currentTimeZone: String!
    var currentDate: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchURLsupportData()
        
        UIApplication.shared.isIdleTimerDisabled = true
        spiner.isHidden = false
        spiner.startAnimating()
        performSupportURL()
        modeCheck()
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
        spiner.isHidden = true
        spiner.stopAnimating()
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
