//
//  AzanVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 12/02/24.
//

import UIKit

class AzanVC: UIViewController {
    
    @IBOutlet weak var fajrView: UIView!
    @IBOutlet weak var sunriseView: UIView!
    @IBOutlet weak var dhuhrView: UIView!
    @IBOutlet weak var sunsetView: UIView!
    @IBOutlet weak var maghribView: UIView!
    
    @IBOutlet weak var fajrStepper: UIStepper!
    @IBOutlet weak var sunriseStepper: UIStepper!
    @IBOutlet weak var dhuhrStepper: UIStepper!
    @IBOutlet weak var sunsetStepper: UIStepper!
    @IBOutlet weak var maghribStepper: UIStepper!
    
    
    @IBOutlet weak var fajr_Lbl_OnTime: UILabel!
    @IBOutlet weak var sunrise_Lbl_OnTime: UILabel!
    @IBOutlet weak var dhuhr_Lbl_OnTime: UILabel!
    @IBOutlet weak var sunset_Lbl_OnTime: UILabel!
    @IBOutlet weak var maghrib_Lbl_OnTime: UILabel!
    

    @IBOutlet weak var fajrTime: UILabel!
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var dhuhrTime: UILabel!
    @IBOutlet weak var sunsetTime: UILabel!
    @IBOutlet weak var maghribTime: UILabel!
    
    
    @IBOutlet weak var fajrSwitch: UISwitch!
    @IBOutlet weak var sunriseSwitch: UISwitch!
    @IBOutlet weak var dhuhrSwitch: UISwitch!
    @IBOutlet weak var sunsetSwitch: UISwitch!
    @IBOutlet weak var maghribSwitch: UISwitch!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // checkMe()
        
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        let dateString = dateFormatter.string(from: currentDate)
//        print(dateString)
//        print(fajrTm)
        
        customeView()
        updateStepperValu()
        liveAzanTime()
        customStepper(stepper: fajrStepper)
        customStepper(stepper: sunriseStepper)
        customStepper(stepper: dhuhrStepper)
        customStepper(stepper: sunsetStepper)
        customStepper(stepper: maghribStepper)
    
  
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        customeTimeStepper()
        customSwitch()
    }

    
    @IBAction func btnTapBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func fajrStepperTap(_ sender: UIStepper) {
        
       let valu = sender.value
      
        if valu == 0.0 {
            
            fajr_Lbl_OnTime.text = "On Time"
            UserDefaults.standard.setValue("On Time", forKey: "fajrTimeLbl")
            UserDefaults.standard.setValue(0.0, forKey: "Fajrvalu")
            

        }
        else if valu > 0.0 {
            
            fajr_Lbl_OnTime.text = "\(Int(valu)) min after"
            UserDefaults.standard.setValue("\(Int(valu)) min after", forKey: "fajrTimeLbl")
            UserDefaults.standard.setValue(valu, forKey: "Fajrvalu")
            
        }
        else if valu < 0.0 {
            
            let newVal = abs(Int(valu))
            
            fajr_Lbl_OnTime.text =  "\(newVal) min before"
            UserDefaults.standard.setValue("\(newVal) min before", forKey: "fajrTimeLbl")
            UserDefaults.standard.setValue(valu, forKey: "Fajrvalu")
            
        }
        
    }
    
    @IBAction func sunriseStepperTap(_ sender: UIStepper) {
        
        let valu = sender.value
       
         if valu == 0.0 {
             
             sunrise_Lbl_OnTime.text = "On Time"
             UserDefaults.standard.setValue("On Time", forKey: "sunriseTimeLbl")
             UserDefaults.standard.setValue(0.0, forKey: "Sunrisevalu")

         }
         else if valu > 0.0 {
             
             sunrise_Lbl_OnTime.text = "\(Int(valu)) min after"
             UserDefaults.standard.setValue("\(Int(valu)) min after", forKey: "sunriseTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Sunrisevalu")
             
         }
         else if valu < 0.0 {
             
             let newVal = abs(Int(valu))
             
             sunrise_Lbl_OnTime.text =  "\(newVal) min before"
             UserDefaults.standard.setValue("\(newVal) min before", forKey: "sunriseTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Sunrisevalu")
             
         }
        
    }
    
    @IBAction func dhuhrStepperTap(_ sender: UIStepper) {
        
        let valu = sender.value
       
         if valu == 0.0 {
             
             dhuhr_Lbl_OnTime.text = "On Time"
             UserDefaults.standard.setValue("On Time", forKey: "dhuhrTimeLbl")
             UserDefaults.standard.setValue(0.0, forKey: "Dhuhrvalu")

         }
         else if valu > 0.0 {
             
             dhuhr_Lbl_OnTime.text = "\(Int(valu)) min after"
             UserDefaults.standard.setValue("\(Int(valu)) min after", forKey: "dhuhrTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Dhuhrvalu")
             
         }
         else if valu < 0.0 {
             
             let newVal = abs(Int(valu))
             
             dhuhr_Lbl_OnTime.text =  "\(newVal) min before"
             UserDefaults.standard.setValue("\(newVal) min before", forKey: "dhuhrTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Dhuhrvalu")
             
         }
        
        
    }
    
    @IBAction func sunsetStepperTap(_ sender: UIStepper) {
        
        let valu = sender.value
       
         if valu == 0.0 {
             
             sunset_Lbl_OnTime.text = "On Time"
             UserDefaults.standard.setValue("On Time", forKey: "sunsetTimeLbl")
             UserDefaults.standard.setValue(0.0, forKey: "Sunsetvalu")

         }
         else if valu > 0.0 {
             
             sunset_Lbl_OnTime.text = "\(Int(valu)) min after"
             UserDefaults.standard.setValue("\(Int(valu)) min after", forKey: "sunsetTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Sunsetvalu")
             
         }
         else if valu < 0.0 {
             
             let newVal = abs(Int(valu))
             
             sunset_Lbl_OnTime.text =  "\(newVal) min before"
             UserDefaults.standard.setValue("\(newVal) min before", forKey: "sunsetTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Sunsetvalu")
             
         }
        
        
    }

    @IBAction func maghribStepperTap(_ sender: UIStepper) {
        
        let valu = sender.value
       
         if valu == 0.0 {
             
             maghrib_Lbl_OnTime.text = "On Time"
             UserDefaults.standard.setValue("On Time", forKey: "maghribTimeLbl")
             UserDefaults.standard.setValue(0.0, forKey: "Maghribvalu")

         }
         else if valu > 0.0 {
             
             maghrib_Lbl_OnTime.text = "\(Int(valu)) min after"
             UserDefaults.standard.setValue("\(Int(valu)) min after", forKey: "maghribTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Maghribvalu")
             
         }
         else if valu < 0.0 {
             
             let newVal = abs(Int(valu))
             
             maghrib_Lbl_OnTime.text =  "\(newVal) min before"
             UserDefaults.standard.setValue("\(newVal) min before", forKey: "maghribTimeLbl")
             UserDefaults.standard.setValue(valu, forKey: "Maghribvalu")
             
         }
        
    }
    
    
    
    @IBAction func fajrSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
            UserDefaults.standard.setValue("isOne", forKey: "fajrSwitch_On_Off")
            playAzan()
        } else {
            
            UserDefaults.standard.setValue("isOff", forKey: "fajrSwitch_On_Off")
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.audioPlayer?.pause()
            }
        }
        
        
    }
    
    
    @IBAction func sunriseSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
            UserDefaults.standard.setValue("isOne", forKey: "sunriseSwitch_On_Off")
            
        } else {
            
            UserDefaults.standard.setValue("isOff", forKey: "sunriseSwitch_On_Off")
        }
        
        
    }
    
    
    @IBAction func dhuhrSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
            UserDefaults.standard.setValue("isOne", forKey: "dhuhrSwitch_On_Off")
            
        } else {
            
            UserDefaults.standard.setValue("isOff", forKey: "dhuhrSwitch_On_Off")
            
        }
        
        
    }
    
    
    @IBAction func sunsetSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
            UserDefaults.standard.setValue("isOne", forKey: "sunsetSwitch_On_Off")
            
        } else {
           
            UserDefaults.standard.setValue("isOff", forKey: "sunsetSwitch_On_Off")
            
        }
        
        
        
    }
    
    
    @IBAction func maghribSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            
            UserDefaults.standard.setValue("isOne", forKey: "maghribSwitch_On_Off")
            
        } else {
            
            UserDefaults.standard.setValue("isOff", forKey: "maghribSwitch_On_Off")
            
        }
        
        
    }
    
    
}


extension AzanVC {
    
    func customeView(){
        addViewBorder(view: fajrView)
        addViewBorder(view: sunriseView)
        addViewBorder(view: dhuhrView)
        addViewBorder(view: sunsetView)
        addViewBorder(view: maghribView)
    }

    func addViewBorder(view: UIView){
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    func customStepper(stepper: UIStepper){
        stepper.stepValue = 5.0
        stepper.maximumValue = 60.0
        stepper.minimumValue = -60.0
    }
    
    func liveAzanTime(){
        fajrTime.text = fajrTm
        sunriseTime.text = sunriseTm
        dhuhrTime.text = dhuhrTm
        sunsetTime.text = sunsetTm
        maghribTime.text = maghribTm
    }
    
    func customeTimeStepper(){
        
        let fajrTimeLbl = UserDefaults.standard.string(forKey: "fajrTimeLbl")
        if fajrTimeLbl  == nil {
            
            fajr_Lbl_OnTime.text = "On Time"
            
        } else {
            
            fajr_Lbl_OnTime.text = fajrTimeLbl
        }
        
        
        let sunriseTimeLbl = UserDefaults.standard.string(forKey: "sunriseTimeLbl")
        
        if sunriseTimeLbl == nil {
            
            sunrise_Lbl_OnTime.text = "30 min before"
            sunriseStepper.value = -30.0
            
        } else {
            
            sunrise_Lbl_OnTime.text = sunriseTimeLbl
            
        }
        
        let dhuhrTimeLbl = UserDefaults.standard.string(forKey: "dhuhrTimeLbl")
        
        if dhuhrTimeLbl == nil {
            
            dhuhr_Lbl_OnTime.text = "On Time"
            
        } else {
            
            dhuhr_Lbl_OnTime.text = dhuhrTimeLbl
            
        }
        
        let sunsetTimeLbl = UserDefaults.standard.string(forKey: "sunsetTimeLbl")
        
        if sunsetTimeLbl == nil {
            
            sunset_Lbl_OnTime.text = "30 min before"
            sunsetStepper.value = -30.0
            
        } else {
            
            sunset_Lbl_OnTime.text = sunsetTimeLbl
            
        }
        
        let maghribTimeLbl = UserDefaults.standard.string(forKey: "maghribTimeLbl")
        
        if maghribTimeLbl == nil {
            
            maghrib_Lbl_OnTime.text = "On Time"
            
        } else {
            
            maghrib_Lbl_OnTime.text = maghribTimeLbl
            
        }
        
    }
    
    func updateStepperValu(){
        
        let fajrvalu = UserDefaults.standard.double(forKey: "Fajrvalu")
        if fajrvalu == nil {
            fajrStepper.value = 0.0
        } else {
            fajrStepper.value = fajrvalu
        }
        
        
        
        let sunrisevalu = UserDefaults.standard.double(forKey: "Sunrisevalu")
        if sunrisevalu == nil {
            sunriseStepper.value = -30.0
        } else {
            sunriseStepper.value = sunrisevalu
        }
        
        
        
        let dhuhrvalu = UserDefaults.standard.double(forKey: "Dhuhrvalu")
        if dhuhrvalu == nil {
            dhuhrStepper.value = 0.0
        } else {
            dhuhrStepper.value = dhuhrvalu
        }
        
        
        let sunsetvalu = UserDefaults.standard.double(forKey: "Sunsetvalu")
        if sunsetvalu == nil {
            sunsetStepper.value = -30.0
        } else {
            sunsetStepper.value = sunsetvalu
        }
        
        
        let maghribvalu = UserDefaults.standard.double(forKey: "Maghribvalu")
        if maghribvalu == nil {
            maghribStepper.value = 0.0
        } else {
            maghribStepper.value = maghribvalu
        }
        
        
    }
    
    func customSwitch(){
        
        let fajrSwitch_On_Off = UserDefaults.standard.string(forKey: "fajrSwitch_On_Off")
        
        if fajrSwitch_On_Off == "isOne" {
            fajrSwitch.isOn = true
        } else {
            fajrSwitch.isOn = false
        }
       
        
        
        let sunriseSwitch_On_Off = UserDefaults.standard.string(forKey: "sunriseSwitch_On_Off")
       
        if sunriseSwitch_On_Off == "isOff" {
            sunriseSwitch.isOn = false
        } else {
            sunriseSwitch.isOn = true
        }
        
        
        
        let dhuhrSwitch_On_Off = UserDefaults.standard.string(forKey: "dhuhrSwitch_On_Off")
       
        if dhuhrSwitch_On_Off == "isOff" {
            dhuhrSwitch.isOn = false
        } else  {
            dhuhrSwitch.isOn = true
        }
        
        
        let sunsetSwitch_On_Off = UserDefaults.standard.string(forKey: "sunsetSwitch_On_Off")
       
        if sunsetSwitch_On_Off == "isOff" {
            sunsetSwitch.isOn = false
        } else {
            sunsetSwitch.isOn = true
        }
        
        
        let maghribSwitch_On_Off = UserDefaults.standard.string(forKey: "maghribSwitch_On_Off")
        if maghribSwitch_On_Off == "isOff" {
            maghribSwitch.isOn = false
        } else {
            maghribSwitch.isOn = true
        }
        
    }
    
    func playAzan(){
        
        let content = UNMutableNotificationContent()
        content.title = AppName
        content.body = "Azan"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
       // let components = Calendar.current.dateComponents([.hour, .minute], from: alarmTime)
        let request = UNNotificationRequest(identifier: "your_notification_identifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
        
        
    }
    
    
    
    
    func checkMe(){

        let currentDate = Date()
        var nWTime = ""
        print(currentDate)
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        let strDate = date.string(from: currentDate)
       
        
        let myTime = "\(strDate) \(fajrTm!)"
        if let newTimeString = addMinutes(to: myTime, minutes: -60) {
            print("Original time: \(myTime)")
            print("Time after adding 60 minutes: \(newTimeString)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let date = dateFormatter.date(from: newTimeString) {
                print(date)
            } else {
                print("Invalid time format")
            }
        } else {
            print("Failed to add minutes to the time string.")
        }
 
        
        // Time + & -
        func addMinutes(to timeString: String, minutes: Int) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            if let time = dateFormatter.date(from: timeString) {
                let calendar = Calendar.current
                let modifiedTime = calendar.date(byAdding: .minute, value: minutes, to: time)
            
                if let modifiedTime = modifiedTime {
                    return dateFormatter.string(from: modifiedTime)
                }
            }
            return nil
        }
        
    }
    
    
}
//2024-02-21
//"yyyy-MM-dd HH:mm"
