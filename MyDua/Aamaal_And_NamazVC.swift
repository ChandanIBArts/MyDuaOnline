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
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let url = URL(string: "https://mydua.online/aamaal-and-namaz/")!
        webView.load(URLRequest(url: url))
        spiner.isHidden = true
        spiner.stopAnimating()
    }
    
    
   
}
