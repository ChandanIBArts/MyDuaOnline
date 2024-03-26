//
//  DetailsFavTVCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 22/03/24.
//

import UIKit

class DetailsFavTVCell: UITableViewCell {
    
    
    @IBOutlet weak var favouriteTitleLbl: UILabel!
    @IBOutlet weak var favourtiteImage: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var duration_Lbl: UILabel!

    var isTap = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sepratorView.layer.cornerRadius = 10.0
        sepratorView.layer.borderWidth = 1.5
        sepratorView.layer.borderColor = UIColor.black.cgColor
        favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green)
        favourtiteImage.isUserInteractionEnabled = true
        favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToFav)))
    }

    @objc func addToFav(){
        if isTap == false {
           favourtiteImage.image = UIImage(named: "unFavourite")
           isTap = true
       } else if isTap == true {
           favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green)
           isTap = false
       }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
