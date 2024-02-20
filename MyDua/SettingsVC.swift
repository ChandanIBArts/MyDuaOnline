//
//  SettingsVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 15/11/23.
//

import UIKit

class SettingsVC: UIViewController {
    
    
    static var viewMode: String!
    
    @IBOutlet weak var settings: UITabBarItem! {
        didSet{
            settings.image = UIImage(named: "settings")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    @IBOutlet weak var lblChangeMode: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var changeModeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        customeBorder(view: changeModeView)
       
       
        if SettingsVC.viewMode == "Dark" {
            modeSwitch.isOn = true
            overrideUserInterfaceStyle = .dark
            changeModeView.layer.borderColor = UIColor.white.cgColor
            
        } else {
            modeSwitch.isOn = false
            overrideUserInterfaceStyle = .light
            changeModeView.layer.borderColor = UIColor.black.cgColor
            
        }
        
        
    }
    
    func customeBorder(view: UIView){
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIApplication.shared.isIdleTimerDisabled = false
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

    @IBAction func modeSwitch(_ sender: UISwitch) {
        //switchCheck()
        if modeSwitch.isOn == true {
            overrideUserInterfaceStyle = .dark
            SettingsVC.viewMode = "Dark"
            lblChangeMode.text = "Change to light mode"
            changeModeView.layer.borderColor = UIColor.white.cgColor
           
            //print(SettingsVC.viewMode)
            } else {
            overrideUserInterfaceStyle = .light
            SettingsVC.viewMode = "Light"
            lblChangeMode.text = "Change to dark mode"
            changeModeView.layer.borderColor = UIColor.black.cgColor
            
            // print(SettingsVC.viewMode)
        }
    }
    
}
