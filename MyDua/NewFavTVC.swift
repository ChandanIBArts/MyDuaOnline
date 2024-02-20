//
//  NewFavTVC.swift
//  MyDua
//
//  Created by DIPSHIKHA KUMARI on 04/12/23.
//

import UIKit

class NewFavTVC: UITableViewCell {
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    {
        didSet{
            imgView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    {
        didSet{
            viewBg.layer.cornerRadius = 8
            viewBg.layer.borderWidth = 1
            viewBg.layer.borderColor = UIColor.black.cgColor
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
