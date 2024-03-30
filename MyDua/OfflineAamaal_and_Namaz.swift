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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadingTVCell", for: indexPath) as! HeadingTVCell
        cell.titleLbl.text = testModel[indexPath.row].aamaal_type
        cell.arrRecord = testModel[indexPath.row].amalRecord
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    
}

