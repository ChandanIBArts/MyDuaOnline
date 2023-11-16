//
//  AlertMessage.swift
//  MyDua
//
//  Created by IB Arts Mac on 09/11/23.
//

import Foundation
import UIKit

final class AlertMessageController{
    class func ShowAlert(title:String,messgae:String,vc:UIViewController){
        let controller = UIAlertController(title: title, message: messgae, preferredStyle: .alert)
        let done = UIAlertAction(title: "OK", style: .cancel)
        controller.addAction(done)
        DispatchQueue.main.async {
            vc.present(controller, animated: true)
        }
    }
}
