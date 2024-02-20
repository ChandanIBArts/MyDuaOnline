//
//  SignupVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 15/11/23.
//

import UIKit

class SignupVC: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var txtUserName: UITextField!
    {
        didSet{
            txtUserName.layer.cornerRadius = 8
            txtUserName.layer.borderWidth = 1
            txtUserName.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    @IBOutlet weak var txtFirstName: UITextField!
    {
        didSet{
            txtFirstName.layer.cornerRadius = 8
            txtFirstName.layer.borderWidth = 1
            txtFirstName.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    @IBOutlet weak var txtLastName: UITextField!
    {
        didSet{
            txtLastName.layer.cornerRadius = 8
            txtLastName.layer.borderWidth = 1
            txtLastName.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    @IBOutlet weak var txtEmail: UITextField!
    {
        didSet{
            txtEmail.layer.cornerRadius = 8
            txtEmail.layer.borderWidth = 1
            txtEmail.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    @IBOutlet weak var txtPassword: UITextField!
    {
        didSet{
            txtPassword.layer.cornerRadius = 8
            txtPassword.layer.borderWidth = 1
            txtPassword.layer.borderColor = UIColor.black.cgColor
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createAccountBtn.isEnabled = false
        hide_Keyboard()
    }
    func hide_Keyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        modeCheck()
        if traitCollection.userInterfaceStyle == .dark{
            txtUserName.layer.borderColor = UIColor.white.cgColor
            txtFirstName.layer.borderColor = UIColor.white.cgColor
            txtLastName.layer.borderColor = UIColor.white.cgColor
            txtEmail.layer.borderColor = UIColor.white.cgColor
            txtPassword.layer.borderColor = UIColor.white.cgColor
            
        }else{
            txtUserName.layer.borderColor = UIColor.black.cgColor
            txtFirstName.layer.borderColor = UIColor.black.cgColor
            txtLastName.layer.borderColor = UIColor.black.cgColor
            txtEmail.layer.borderColor = UIColor.black.cgColor
            txtPassword.layer.borderColor = UIColor.black.cgColor
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
    
    @IBAction func conditionSwitch(_ sender: UISwitch) {
        if sender.isOn {
            createAccountBtn.backgroundColor = .systemGreen
            createAccountBtn.isEnabled = true
        } else {
            createAccountBtn.backgroundColor = .systemGray4
            createAccountBtn.isEnabled = false
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        let signInStoryboard = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(signInStoryboard, animated: true)
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        
        if txtUserName.text == "" || txtFirstName.text == "" || txtLastName.text == "" || txtEmail.text == "" || txtPassword.text == "" {
            let alert = UIAlertController(title: AppName, message: "Please input userid details", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        } else {
            
            self.callSignUpAPI()
        }
    }
    
    func setupUI() {
        formView.layer.cornerRadius = 8.0
        createAccountBtn.layer.cornerRadius = 8.0
    }
}
extension SignupVC {
    
    func callSignUpAPI(){
        
             let objSingletion = SingletonApi()
        objSingletion.SignUpApi(username:txtUserName.text ?? "",firstname:txtFirstName.text ?? "",lastname:txtLastName.text ?? "",email:txtEmail.text ?? "",password:txtPassword.text ?? "", onSuccess: { response in
            
            
                 print("Got Response")
                 print(response )
                 DispatchQueue.main.async {
                     if response["type"] == "success"{
                        
                        
                         let alert = UIAlertController(title: AppName, message: "SignUp Successfully!", preferredStyle: .alert)
                         alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                        
                             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                             let signinVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                             //signinVC.selectedIndex = 0
                             self.navigationController?.pushViewController(signinVC, animated: true)
                             
                         }))
                         
                         self.present(alert, animated: true)
                     } else {
                        // MessageAlertController.ShowAlert(title: AppName, messgae: response["message"].stringValue, vc: self)
                     }
                 }
                 
             }, onError: { message in
                 print(message as Any)
                 DispatchQueue.main.async {
                    // MessageAlertController.ShowAlert(title: AppName, messgae: message ?? "", vc: self)
                 }
             })
    }
}
