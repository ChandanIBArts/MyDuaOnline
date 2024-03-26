//
//  FavouriteTVCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 21/03/24.
//

import UIKit

class FavouriteTVCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblFavouriteTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
