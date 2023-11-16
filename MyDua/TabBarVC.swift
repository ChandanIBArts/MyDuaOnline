//
//  TabBarVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit

class TabBarVC: UITabBarController {

    @IBOutlet weak var tabBarView: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
      
    }
    func setupUI() {
        tabBarView.layer.borderWidth = 0.2
        tabBarView.backgroundColor = .systemGreen
    }
}
