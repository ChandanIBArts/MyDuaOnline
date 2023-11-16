//
//  SigninVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 15/11/23.
//

import UIKit

class SigninVC: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
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
