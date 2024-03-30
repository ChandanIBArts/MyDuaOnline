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
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var pdfTableview: UITableView!

    var arrRecord = [ArabicAamaall.AamallRecord]()

    override func awakeFromNib() {
        super.awakeFromNib()
        pdfTableview.dataSource = self
        pdfTableview.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HeadingTVCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRecord.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pdfTableview.dequeueReusableCell(withIdentifier: "PdfTVCell", for: indexPath) as! PdfTVCell
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350//UITableView.automaticDimension
    }
    
}
