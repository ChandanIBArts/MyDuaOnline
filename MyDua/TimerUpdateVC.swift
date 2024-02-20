//
//  TimerUpdateVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 25/01/24.
//

import UIKit

class TimerUpdateVC: UIViewController {
    
    @IBOutlet weak var lblHijri: UILabel!
    @IBOutlet weak var pikerView: UIPickerView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    
    let timeArr = ["-2", "-1", "0", "+1", "+2"]
    var updateDay = 0
    var isON: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.isHidden = true
        spiner.stopAnimating()
        pikerView.layer.borderWidth = 1
        pikerView.layer.borderColor = UIColor.black.cgColor
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        changeDate()
        pikerView.dataSource = self
        pikerView.delegate = self
        pikerView.isHidden = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        changeDate()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
   
    @IBAction func btnTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChangeTimer(_ sender: UIButton) {
        
        if isON != true {
            pikerView.isHidden = false
            isON = true
        }
        else {
            pikerView.isHidden = true
            isON = false
        }
        
    }
    
    func changeDate(){
        updateDay = UserDefaults.standard.integer(forKey: "UpdateDate")
        if updateDay == nil || updateDay == 0 {
            
            setTimeZone(day: 0)
            lblTime.text = String(0)
            
        } else {
            
            setTimeZone(day: updateDay)
            lblTime.text = String(updateDay)
        }
        
    }
    
    func setTimeZone(day: Int){
        
        let objSingleton = SingletonApi()
        objSingleton.hijriTimeZoneChange(day: day, onSuccess: { response in
            
            print(response)
            DispatchQueue.main.async {
                let hijriText = response["hijri_date"].stringValue
                var testText = response["event"].stringValue
                var eventColor = response["event_color"].stringValue
   
                if testText == "" {
                    testText = testText
                } else {
                    testText = "(\(testText))"
                }
                //MARK: make attributedString
                var attributedString = NSMutableAttributedString(string: "\(hijriText) \n \(testText)")
                let range = NSString(string: "\(hijriText) \n \(testText)").range(of: "\(testText)", options: String.CompareOptions.caseInsensitive)
                
                let changeColor = self.hexStringToUIColor(hex: eventColor)
                
                //attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: range)
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: changeColor], range: range)
                self.lblHijri.attributedText = attributedString
                self.spiner.isHidden = true
                self.spiner.stopAnimating()
            }
            
        }, onError: { message in
            print(message as Any)
        })
    
    }
    
}

extension TimerUpdateVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        timeArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            updateDay = -2
            setTimeZone(day: updateDay)
            pikerView.isHidden = true
            isON = false
            UserDefaults.standard.setValue(-2, forKey: "UpdateDate")
            lblTime.text = String(-2)
            spiner.isHidden = false
            spiner.startAnimating()
        case 1:
            updateDay = -1
            setTimeZone(day: updateDay)
            pikerView.isHidden = true
            isON = false
            UserDefaults.standard.setValue(-1, forKey: "UpdateDate")
            lblTime.text = String(-1)
            spiner.isHidden = false
            spiner.startAnimating()
        case 2:
            updateDay = 0
            setTimeZone(day: updateDay)
            pikerView.isHidden = true
            isON = false
            UserDefaults.standard.setValue(0, forKey: "UpdateDate")
            lblTime.text = String(0)
            spiner.isHidden = false
            spiner.startAnimating()
        case 3:
            updateDay = 1
            setTimeZone(day: updateDay)
            pikerView.isHidden = true
            isON = false
            UserDefaults.standard.setValue(1, forKey: "UpdateDate")
            lblTime.text = String(1)
            spiner.isHidden = false
            spiner.startAnimating()
        case 4:
            updateDay = 2
            setTimeZone(day: updateDay)
            pikerView.isHidden = true
            isON = false
            UserDefaults.standard.setValue(2, forKey: "UpdateDate")
            lblTime.text = String(2)
            spiner.isHidden = false
            spiner.startAnimating()
        default:
            break
            
        }
    }
    
}
extension TimerUpdateVC {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
// var myColor = hexStringToUIColor(hex: "#1b8415" )
//myLbl.textColor = myColor
