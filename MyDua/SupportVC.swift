//
//  SupportVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 10/01/24.
//

import UIKit
import WebKit


class SupportVC: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        spiner.isHidden = false
        spiner.startAnimating()
        performSupportURL()
        modeCheck()
        // Do any additional setup after loading the view.
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

    @IBAction func btnBack(_ sender: UIButton) {
     navigationController?.popViewController(animated: true)
    }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

    
    private func performSupportURL(){
        let url = URL(string: "https://mydua.online/our-supporter/")!
        webView.load(URLRequest(url: url))
        spiner.isHidden = true
        spiner.stopAnimating()
    }
    
}
