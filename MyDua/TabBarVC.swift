//
//  TabBarVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
var globalUserID = ""
class TabBarVC: UITabBarController,UITabBarControllerDelegate {

    @IBOutlet weak var tabBarView: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.delegate = self
      
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
    }
    func setupUI() {
        tabBarView.layer.borderWidth = 0.2
        tabBarView.backgroundColor = .systemGreen
       // tabBarView.backgroundColor = .black
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let idx = tabBarController.selectedIndex
        print(idx)
        hideViewControllerAtIndex(idx)
//        if idx == 4{
//            let vc = moreNavigationController.viewControllers
//            for (i,j) in vc.enumerated(){
//                print(i)
//            }
//            
//        }
    }
    
    func hideViewControllerAtIndex(_ index: Int) {
           // Access the moreNavigationController and its view controllers
        let moreNavigationController = moreNavigationController
              var moreViewControllers = moreNavigationController.viewControllers
            if  index >= 0 && index < moreViewControllers.count {
               
               // Remove the view controller at the specified index
               moreViewControllers.remove(at: index)
               
               // Set the updated array of view controllers
               moreNavigationController.setViewControllers(moreViewControllers, animated: false)
           }
       }
 
    
}
