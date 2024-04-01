//
//  HeadingTVCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 30/03/24.
//

import UIKit
import SwiftyJSON
import Alamofire

class HeadingTVCell: UITableViewCell {
    
    @IBOutlet weak var titelView: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titelView.layer.cornerRadius = 10
        titelView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

