//
//  ChangePasswordVC.swift
//  MyDua
//
//  Created by DIPSHIKHA KUMARI on 29/11/23.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtOldpassword: UITextField!
    {
        didSet{
            txtOldpassword.layer.cornerRadius = 8
            txtOldpassword.layer.borderWidth = 1
            txtOldpassword.layer.borderColor = UIColor.black.cgColor
            txtOldpassword.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        }
    }
    @IBOutlet weak var txtNewpassword: UITextField!
    {
        didSet{
            txtNewpassword.layer.cornerRadius = 8
            txtNewpassword.layer.borderWidth = 1
            txtNewpassword.layer.borderColor = UIColor.black.cgColor
            txtNewpassword.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        }
    }
    @IBOutlet weak var txtChangePass: UITextField!
    {
        didSet{
            txtChangePass.layer.cornerRadius = 8
            txtChangePass.layer.borderWidth = 1
            txtChangePass.layer.borderColor = UIColor.black.cgColor
            txtChangePass.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        }
    }
    @IBOutlet weak var btnUpdate: UIButton!
    {
        didSet{
            btnUpdate.layer.cornerRadius = 8
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hide_Keyboard()
        // Do any additional setup after loading the view.
    }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    func hide_Keyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisKeyboard(){
        view.endEditing(true)
    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func btnUpdate(_ sender: Any) {
        let objSingletion = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""

        objSingletion.ChangePasswordApi(userId:userId,oldpassword:txtOldpassword.text ?? "",newpassword:txtNewpassword.text ?? "",changepassword:txtChangePass.text ?? "",onSuccess: { response in
            print("Got Response")
            print(response )
            DispatchQueue.main.async {
                if response["type"] == "success"{
                    let alert = UIAlertController(title: AppName, message: response["msg"].stringValue, preferredStyle: .alert)
                    let ac1 = UIAlertAction(title: "OK", style: .default) { _ in
                        UserDefaults.standard.setValue("", forKey: "UserID")
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }
                 
                  
                    DispatchQueue.main.async {
                        alert.addAction(ac1)
                       
                        self.present(alert, animated: true)
                    }
                    

                    /*
                    AlertMessageController.ShowAlert(title: AppName, messgae: response["msg"].stringValue, vc: self)
*/
             
                } else {
                    AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
                }
            }
            
        }, onError: { message in
            print(message as Any)
            DispatchQueue.main.async {
                //MessageAlertController.ShowAlert(title: AppName, messgae: message ?? "", vc: self)
            }
        })
    }
}
