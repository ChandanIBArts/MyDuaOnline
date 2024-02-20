//
//  MyProfileButtonVC.swift
//  MyDua
//
//  Created by DIPSHIKHA KUMARI on 30/11/23.
//

import UIKit

class MyProfileButtonVC: UIViewController {

    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnMyProfile: UIButton!
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        modeCheck()
        navigationController?.setNavigationBarHidden(true, animated: true)
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
           
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
   
    
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    @IBAction func BtnMyProfile(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signinVC = storyBoard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        //signinVC.selectedIndex = 0
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func btnChangePass(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signinVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        //signinVC.selectedIndex = 0
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Do you want to LogOut", preferredStyle: .alert)
        let ac1 = UIAlertAction(title: "Yes", style: .default) { _ in
            UserDefaults.standard.setValue(0, forKey: "UserID")
            self.navigationController?.popViewController(animated: true)
            
        }
        let ac2 = UIAlertAction(title: "No", style: .cancel) { _ in
            
        }
      
        DispatchQueue.main.async {
            alert.addAction(ac1)
            alert.addAction(ac2)
            self.present(alert, animated: true)
        }
        
    }
    
}
