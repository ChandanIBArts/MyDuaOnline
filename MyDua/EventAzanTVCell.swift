//
//  EventAzanTVCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 14/02/24.
//

import UIKit

class EventAzanTVCell: UITableViewCell {
    
    
    @IBOutlet weak var fajrView: UIView!
    @IBOutlet weak var fajrImg: UIImageView!
    @IBOutlet weak var fajrTitle: UILabel!
    @IBOutlet weak var fajrTime: UILabel!
    
    
    @IBOutlet weak var sunriseView: UIView!
    @IBOutlet weak var sunriseImg: UIImageView!
    @IBOutlet weak var sunriseTitle: UILabel!
    @IBOutlet weak var sunriseTime: UILabel!
    
    
    @IBOutlet weak var dhuhrView: UIView!
    @IBOutlet weak var dhuhrImg: UIImageView!
    @IBOutlet weak var dhuhrTitle: UILabel!
    @IBOutlet weak var dhuhrTime: UILabel!
    
    
    @IBOutlet weak var sunsetView: UIView!
    @IBOutlet weak var sunsetImg: UIImageView!
    @IBOutlet weak var sunsetTitle: UILabel!
    @IBOutlet weak var sunsetTime: UILabel!
    
    
    @IBOutlet weak var maghribView: UIView!
    @IBOutlet weak var maghribImg: UIImageView!
    @IBOutlet weak var maghribTitle: UILabel!
    @IBOutlet weak var maghribTime: UILabel!
    
    @IBOutlet weak var lblLiveEventName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        customView(view: fajrView)
        customView(view: sunriseView)
        customView(view: dhuhrView)
        customView(view: sunsetView)
        customView(view: maghribView)
    }

    func customView(view: UIView){
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
    }
    
}
