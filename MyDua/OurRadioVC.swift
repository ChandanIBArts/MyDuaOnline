//
//  OurRadioVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import WebKit
import UIKit
import AVKit

class OurRadioVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var customAirPlayView: UIView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var radio: UITabBarItem!{
        didSet{
            radio.image = UIImage(named: "radio")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }

    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        spiner.isHidden = false
        spiner.startAnimating()
        performURL()
        airplaybtnSet()
        modeCheck()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func airplaybtnSet(){
        let buttonView  = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let routerPickerView =  AVRoutePickerView(frame: buttonView.bounds)
         routerPickerView.tintColor = UIColor.white
         routerPickerView.activeTintColor = .white
         buttonView.addSubview(routerPickerView)
         self.customAirPlayView.addSubview(buttonView)
      }
    
    
    func performURL(){
        let url = URL(string: "https://azadar.media")!
        webView.load(URLRequest(url: url))
        spiner.isHidden = true
        spiner.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        modeCheck()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

}
