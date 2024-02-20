//
//  NewFavCVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 05/01/24.
//

import UIKit

class NewFavCVC: UICollectionViewCell {
    @IBOutlet weak var imgFav: UIImageView!
    @IBOutlet weak var lblFav: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgFav.layer.cornerRadius = 8
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        backView.layer.borderWidth = 1
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true
        
    }
    
    
}
