//
//  EventTVCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 05/02/24.
//

import UIKit

class EventTVCell: UITableViewCell {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDuration: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sepratorView.layer.cornerRadius = 20.0
        sepratorView.layer.borderWidth = 0.7
        sepratorView.layer.borderColor = UIColor(.black).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
