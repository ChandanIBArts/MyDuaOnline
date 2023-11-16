//
//  LoginVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var login: UITabBarItem!{
        didSet{
            login.image = UIImage(named: "profile-user")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

    @IBAction func signupTapped(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signinVC = storyBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(signinVC, animated: true)
    }
    
    func setupUI() {
        formView.layer.cornerRadius = 8.0
        loginBtn.layer.cornerRadius = 8.0
    }

}
