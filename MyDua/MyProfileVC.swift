//
//  MyProfileVC.swift
//  MyDua
//
//  Created by DIPSHIKHA KUMARI on 28/11/23.
//

import UIKit


class MyProfileVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var flag: Bool = true
    
    @IBOutlet weak var genderPicker: UIPickerView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    {
        didSet
        {
            txtFirstName.layer.cornerRadius = 8
            txtFirstName.layer.borderColor = UIColor.black.cgColor
            txtFirstName.layer.borderWidth = 2
            txtFirstName.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
            
        }
    }
    @IBOutlet weak var txtLastName: UITextField!
    {
        didSet
        {
            txtLastName.layer.cornerRadius = 8
            txtLastName.layer.borderColor = UIColor.black.cgColor
            txtLastName.layer.borderWidth = 2
            txtLastName.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
            
        }
    }
    @IBOutlet weak var txtEmail: UITextField!
    {
        didSet
        {
            txtEmail.layer.cornerRadius = 8
            txtEmail.layer.borderColor = UIColor.black.cgColor
            txtEmail.layer.borderWidth = 2
            txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        }
    }
    @IBOutlet weak var viewPhoneNo: UIView!
    {
        didSet
        {
            viewPhoneNo.layer.cornerRadius = 8
            viewPhoneNo.layer.borderColor = UIColor.black.cgColor
            viewPhoneNo.layer.borderWidth = 2
            
        }
    }
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    @IBOutlet weak var viewGender: UIView!
    {
        didSet
        {
            viewGender.layer.cornerRadius = 8
            viewGender.layer.borderColor = UIColor.black.cgColor
            viewGender.layer.borderWidth = 2
            
        }
    }
    @IBOutlet weak var txtGender: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    {
        didSet
        {
            btnSave.layer.cornerRadius = 8
            // btnSave.layer.borderColor = UIColor.black.cgColor
            // btnSave.layer.borderWidth = 2
            
        }
    }
    let genders = ["Male", "Female", "Other"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
       
        // modeCheck()
        modeCheck()
        if traitCollection.userInterfaceStyle == .dark{
            viewPhoneNo.layer.borderColor = UIColor.white.cgColor
            txtFirstName.layer.borderColor = UIColor.white.cgColor
            txtLastName.layer.borderColor = UIColor.white.cgColor
            txtEmail.layer.borderColor = UIColor.white.cgColor
            viewGender.layer.borderColor = UIColor.white.cgColor
            
        }else{
            viewPhoneNo.layer.borderColor = UIColor.black.cgColor
            txtFirstName.layer.borderColor = UIColor.black.cgColor
            txtLastName.layer.borderColor = UIColor.black.cgColor
            txtEmail.layer.borderColor = UIColor.black.cgColor
            viewGender.layer.borderColor = UIColor.black.cgColor
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.isHidden = true
        flag = !true
        APIcall()
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
    
    @IBAction func btnSelectGender(_ sender: UIButton) {
        
        if flag == false {
            genderPicker.isHidden = false
            flag = true
        } else {
            genderPicker.isHidden = true
            flag = false
        }
    }
    
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPhoneCode(_ sender: Any) {
    }
    
    @IBAction func btnSave(_ sender: Any) {
        updateProfileApi()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtGender.text = genders[row]
        genderPicker.isHidden = true
        
        
    }
    
    
    func APIcall(){
        let objSingletion = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        
        objSingletion.MyProfileAPI(userId: userId, onSuccess: { response in
            print("Got Response")
            print(response)
            DispatchQueue.main.async {
                self.txtFirstName.text = response["firstname"].stringValue
                self.txtLastName.text = response["lastname"].stringValue
                self.txtEmail.text = response["email"].stringValue
                
                let phoneNumber = response["phone"].stringValue
                self.txtPhoneNo.text = phoneNumber
                self.txtGender.text = response["gender"].stringValue
            }
            
        }, onError: { message in
            
            print(message as Any)
            DispatchQueue.main.async {
                print("It's Error")
            }
            
        })
        
    }
    
    func updateProfileApi(){
        let objSingletion = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        
        var gender: String!
        if txtGender.text == "" {
            gender = ""
        } else {
            gender = txtGender.text
        }
        
        var phonr: String!
        if txtPhoneNo.text == "" {
            phonr = ""
        } else {
            phonr = txtPhoneNo.text
        }
        
        var firstname: String!
        if txtFirstName.text == "" {
            firstname = ""
        } else {
            firstname = txtFirstName.text
        }
        
        var lastname: String!
        if txtLastName.text == "" {
            lastname = ""
        } else {
            lastname = txtLastName.text
        }
        
        objSingletion.UpdateProfile(userid: userId, gender: gender, phonr: phonr, firstname: firstname, lastname: lastname, onSuccess: { response in
            
            DispatchQueue.main.async {
                let msg = response["msg"].stringValue
                // let type = response["type"].stringValue
                let alert = UIAlertController(title: AppName, message: msg, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            
        }, onError: { message in
            
            print(message as Any)
            DispatchQueue.main.async {
                print("It's Error")
            }
        })
        
    }

    
}
