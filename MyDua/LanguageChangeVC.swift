//
//  LanguageChangeVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 15/11/23.
//

import UIKit

class LanguageChangeVC: UIViewController {

    @IBOutlet weak var langView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBOutlet weak var changeLang: UITabBarItem!{
        didSet{
            changeLang.image = UIImage(named: "language")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
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

    func setupUI() {
        langView.layer.cornerRadius = 8.0
    }
}
