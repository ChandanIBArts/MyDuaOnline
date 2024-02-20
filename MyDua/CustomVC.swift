//
//  CustomVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 13/12/23.
//

import UIKit

class CustomVC: UIViewController {

    @IBOutlet weak var viewSurah: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSurah.isUserInteractionEnabled = true
//        viewSurah.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        // Do any additional setup after loading the view.
    }
    @objc func tap(_sender:UITapGestureRecognizer){
        print("hi")
    }

    
 

}
