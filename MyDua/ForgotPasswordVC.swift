//
//  ForgotPasswordVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 12/12/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var resetPasswordBtn: UIButton!
    @IBOutlet weak var textFieldView: UIView!{
        
            didSet
            {
                textFieldView.layer.cornerRadius = 8
                textFieldView.layer.borderColor = UIColor.black.cgColor
                textFieldView.layer.borderWidth = 2
                
            }
        
    }
    @IBOutlet weak var text_EmailOrUsername: UITextField!
    
    var email_Username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        setupUI()
        hide_Keyboard()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        modeCheck()
        
        if traitCollection.userInterfaceStyle == .dark{
            textFieldView.layer.borderColor = UIColor.white.cgColor
           
        }else{
            textFieldView.layer.borderColor = UIColor.black.cgColor
           
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordBtn(_ sender: UIButton) {
        if text_EmailOrUsername.text == "" {
            let alert = UIAlertController(title: AppName, message: "Please input valid email id or username", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else {
            api_Call()
        }
    }
    
    @IBAction func backToLoginBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Keyboard Hide
    func hide_Keyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisKeyboard(){
        view.endEditing(true)
    }
    
    func setupUI(){
        resetPasswordBtn.layer.cornerRadius = 10
        resetPasswordBtn.clipsToBounds = true
        resetPasswordBtn.layer.borderWidth = 0.9
        resetPasswordBtn.layer.borderColor = UIColor.black.cgColor
        
        textFieldView.layer.borderColor = UIColor.black.cgColor
        textFieldView.layer.borderWidth = 0.3
        
        view.endEditing(true)
    }
    
    func api_Call(){
        if let email_Username = text_EmailOrUsername.text, !email_Username.isEmpty {
            self.email_Username = email_Username
        }
        print(self.email_Username!)
        text_EmailOrUsername.text = ""
        
        let objSingletion = SingletonApi()
        
        objSingletion.forgotPasswordAPI(email: self.email_Username, onSuccess: { response in
            print("Got Response")
            print(response )
            DispatchQueue.main.async {
                if response ["type"] == "success"{
                    let returnMessage = response["message"].stringValue
                    print(returnMessage)
                    
                    let alert = UIAlertController(title: AppName, message: returnMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                        
                        let signInStoryboard = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(signInStoryboard, animated: true)
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                        let signinVC = storyBoard.instantiateViewController(withIdentifier: "MyProfileButtonVC") as! MyProfileButtonVC
//                        //signinVC.selectedIndex = 0
//                        self.navigationController?.pushViewController(signinVC, animated: true)
                        
                    }))
                    
                    self.present(alert, animated: true)
                } else {
                    AlertMessageController.ShowAlert(title: AppName, messgae: response["message"].stringValue, vc: self)
                }
            }
            
        }, onError: { message in
            print(message as Any)
            DispatchQueue.main.async {
                AlertMessageController.ShowAlert(title: AppName, messgae: message ?? "", vc: self)
            }
        })
        
    }
    
}
    
    
    
//    func callLoginAPI(){
//        
//        let objSingletion = SingletonApi()
//        objSingletion.LoginApi(email:txtUserName.text ?? "",password:txtPassword.text ?? "", onSuccess: { response in
//            print("Got Response")
//            print(response )
//            DispatchQueue.main.async {
//                if response["type"] == "success"{
//                    //{"message":{"data":{"ID"
//                    let userId = response["message"]["ID"].intValue
//                    UserDefaults.standard.setValue(userId, forKey: "UserID")
//                    print(userId)
//                    //                         userID = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
//                    
//                    let alert = UIAlertController(title: AppName, message: "Login Successfully!", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
//                        
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                        let signinVC = storyBoard.instantiateViewController(withIdentifier: "MyProfileButtonVC") as! MyProfileButtonVC
//                        //signinVC.selectedIndex = 0
//                        self.navigationController?.pushViewController(signinVC, animated: true)
//                        
//                    }))
//                    
//                    self.present(alert, animated: true)
//                } else {
//                    AlertMessageController.ShowAlert(title: AppName, messgae: response["message"].stringValue, vc: self)
//                }
//            }
//            
//        }, onError: { message in
//            print(message as Any)
//            DispatchQueue.main.async {
//                AlertMessageController.ShowAlert(title: AppName, messgae: message ?? "", vc: self)
//            }
//        })
//    }
//}
