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
    
    @IBAction func signInTapped(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signupVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func setupUI() {
        formView.layer.cornerRadius = 8.0
        createAccountBtn.layer.cornerRadius = 8.0
    }
}
