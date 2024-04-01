//
//  PdfCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 01/04/24.
//

import UIKit

class PdfCell: UITableViewCell {
    
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var pfdLBL: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        musicView.layer.cornerRadius = 10
        musicView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
