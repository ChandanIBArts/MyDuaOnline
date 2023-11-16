//
//  OurRadioVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import WebKit
import UIKit

class OurRadioVC: UIViewController, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var radio: UITabBarItem!{
        didSet{
            radio.image = UIImage(named: "radio")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://azadar.media")!
        webView.load(URLRequest(url: url))
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

}
