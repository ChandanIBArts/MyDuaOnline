//
//  LoginVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit

class LoginVC: UIViewController {
   
    weak var vc:TabBarVC?
    
    @IBOutlet weak var modeView: UIView!
    
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var login: UITabBarItem!{
        didSet{
            login.image = UIImage(named: "profile-user")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        setupUI()
        loginBtn.isEnabled = false
        hide_Keyboard()
        setUi(view: viewUserName)
        setUi(view: viewPassword)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        modeCheck()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    
    }
    
    func setUi(view: UIView){
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
    }

    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
            modeView.backgroundColor = .black
            viewUserName.layer.cornerRadius = 10
            viewUserName.layer.borderColor = UIColor.white.cgColor
            viewUserName.layer.borderWidth = 1
            txtUserName.textColor = UIColor.white
            viewPassword.layer.cornerRadius = 10
            viewPassword.layer.borderColor = UIColor.white.cgColor
            viewPassword.layer.borderWidth = 1
            txtPassword.textColor = UIColor.white
        } else {
            overrideUserInterfaceStyle = .light
            modeView.backgroundColor = .systemBackground
            viewUserName.layer.borderColor = UIColor.black.cgColor
            viewUserName.layer.borderWidth = 1
            txtUserName.textColor = UIColor.black
            viewPassword.layer.cornerRadius = 10
            viewPassword.layer.borderColor = UIColor.black.cgColor
            viewPassword.layer.borderWidth = 1
            txtPassword.textColor = UIColor.black
        }
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func signupTapped(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signinVC = storyBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    @IBAction func switchCondition(_ sender: UISwitch) {
        if sender.isOn {
            loginBtn.backgroundColor = .systemGreen
            loginBtn.isEnabled = true
        } else {
            loginBtn.backgroundColor = .systemGray4
            loginBtn.isEnabled = false
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if txtUserName.text == "" && txtPassword.text == "" {
            let alert = UIAlertController(title: AppName, message: "Please input userid and password", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else if txtUserName.text == "" && txtPassword.text != "" {
            let alert = UIAlertController(title: AppName, message: "Please input a valid userid", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else if txtUserName.text != "" && txtPassword.text == "" {
            let alert = UIAlertController(title: AppName, message: "Please input a valid password", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else {
            self.callLoginAPI()
        }
        txtUserName.text = ""
        txtPassword.text = ""
       }
    
    func setupUI() {
        formView.layer.cornerRadius = 8.0
        loginBtn.layer.cornerRadius = 10
        loginBtn.clipsToBounds = true
        loginBtn.layer.borderColor = UIColor.black.cgColor
        loginBtn.layer.borderWidth = 0.9
    }
    
    

    
    //MARK: Keyboard Hide
    func hide_Keyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        let forgotPasswordStoryboard = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotPasswordStoryboard, animated: true)
    }
    
    

}

extension LoginVC {
    
    func callLoginAPI(){
        
             let objSingletion = SingletonApi()
             objSingletion.LoginApi(email:txtUserName.text ?? "",password:txtPassword.text ?? "", onSuccess: { response in
                 print("Got Response")
                 print(response )
                 DispatchQueue.main.async {
                     if response["type"] == "success"{
                         //{"message":{"data":{"ID"
                         
                         let userId = response["message"]["data"]["ID"].stringValue
                         print(userId)
//                         userID = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
                        
                         let alert = UIAlertController(title: AppName, message: "Login Successfully!", preferredStyle: .alert)
                         alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                             UserDefaults.standard.setValue(userId, forKey: "UserID")
                             self.vc?.viewControllers?.remove(at: 9)
                             
//                             let vc = self.storyboard?.instantiateViewController(identifier: "MyFavouritesVC") as! MyFavouritesVC
//                             self.navigationController?.pushViewController(vc, animated: true)
                             var checkValidation = UserDefaults.standard.integer(forKey: "validation")
                             if checkValidation == 1 {
                                 
                                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
                                 self.navigationController?.pushViewController(vc, animated: true)
                                 
                                 UserDefaults.standard.setValue(0, forKey: "validation")
                                 
                             } else {
                                 
                                 self.navigationController?.popViewController(animated: true)
                             }
                             /*
                             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                             let signinVC = storyBoard.instantiateViewController(withIdentifier: "MyProfileButtonVC") as! MyProfileButtonVC
                             //signinVC.selectedIndex = 0
                             self.navigationController?.pushViewController(signinVC, animated: true)
                             */
                            
                            // self.tabBarController?.tabBar.isHidden = true
                         }))
                         
                         self.present(alert, animated: true)
                     } else {
                         AlertMessageController.ShowAlert(title: AppName, messgae: "Please input valid Userid or password"/*response["Please input valid userid or password"].stringValue*/, vc: self)
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
