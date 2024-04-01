//
//  OfflineAamaal_and_Namaz.swift
//  MyDua
//
//  Created by IB Arts Mac on 30/03/24.
//

import UIKit
import SwiftyJSON
import Alamofire

class OfflineAamaal_and_Namaz: UIViewController {
    
    let objSingleTonAPi = AamaalNamazSingleTonAPI()
    var arabicAamaal: [JSON] = []
    var englishAamaal: [JSON] = []
    var hindiAamaal: [JSON] = []
    var gujaratiAamaal: [JSON] = []
    var flag = false
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var testModel = ArabicAamaall.myAamaallArray
    

    override func viewDidLoad() {
        super.viewDidLoad()

        callAPI()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.reloadData()
    }
    
    @IBAction func btnTapBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func callAPI(){
        objSingleTonAPi.AamaalNamazApi(date: "0", timeZone: "Asia/kolkata", onSuccess: { response in
            DispatchQueue.main.async {
                
                //self.arabicAamaal = response["arabic"].arrayValue
                self.englishAamaal = response["english"].arrayValue
                self.tableview.reloadData()
//                self.hindiAamaal = response["hindi"].arrayValue
//                self.gujaratiAamaal = response["gujarati"].arrayValue
//                print(self.gujaratiAamaal)
                
            }

        }, onError: { massage in
        print(massage as Any)
        })
    }

    

}
extension OfflineAamaal_and_Namaz: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return testModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testModel[section].amalRecord.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadingTVCell", for: IndexPath(row: 0, section: section)) as! HeadingTVCell
        cell.title.text = testModel[section].aamaal_type
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PdfCell", for: indexPath) as! PdfCell
        let arr = testModel[indexPath.section].amalRecord
        if arr[indexPath.row].musicURL == " " {
            cell.musicView.isHidden = true
        } else {
            cell.musicView.isHidden = false
            let tagID = (1000 * (indexPath.section+1)) + indexPath.row
            cell.btnPlay.tag = tagID
            cell.btnPlay.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
        }
        // cell.musicURL.text = arr[indexPath.row].musicURL
        cell.pfdLBL.text = arr[indexPath.row].pdfString
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    @objc func playMusic(_ sender: UIButton) {
        
        let tag = sender.tag as? Int ?? 0
        
        let intRow = tag % 1000
        
        let intSection = (tag / 1000) - 1
    
        let idx = IndexPath(row: intRow, section: intSection)
        
        if let cell = tableview.cellForRow(at: idx) as? PdfCell {
            if flag == false {
                cell.btnPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                flag = true
            } else {
                cell.btnPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                flag = false
            }
        } else {
            print("Cell is nil or not of type PdfCell")
        }
        
    }
    
}

