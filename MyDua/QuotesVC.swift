//
//  QuotesVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 30/01/24.
//

import UIKit
import WebKit

class QuotesVC: UIViewController {
    
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
        super.viewWillAppear(true)
        UIApplication.shared.isIdleTimerDisabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
        let url = URL(string: "https://mydua.online/quotes")!
        webView.load(URLRequest(url: url))
        spiner.isHidden = true
        spiner.stopAnimating()
    }
    
    
}
