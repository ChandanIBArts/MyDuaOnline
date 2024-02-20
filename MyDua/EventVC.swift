//
//  EventVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 01/02/24.
//

import UIKit
import AVKit
import SwiftyJSON
import Alamofire
import MediaPlayer
import CoreTelephony
import SDWebImage

class EventVC: UIViewController {
    
    @IBOutlet weak var customAirPlayView: UIView!
    @IBOutlet weak var floatingLbl: MarqueeLabel!
    @IBOutlet weak var lblHijri: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
        
    @IBOutlet weak var lblMusicTitle: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblMusicDuration: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var tfLang: UITextField!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var eventImgView: UIImageView!
    
    
    let langPicker = UIPickerView()
    var arrLang = ["عربي","English","हिंदी","ગુજરાતી"]
    let audioSpeed = ["0.5x", "0.75x", "normal", "1.25x", "1.5x", "1.75x", "2x", "4x"]
    var speed:Float = 1
    var strLang = "عربي"
    var updateDay: Int?
    var eventName: String?
    var arabicDuaList: [JSON] = []
    var englishduaList: [JSON] = []
    var hindiduaList: [JSON] = []
    var gujratiduaList: [JSON] = []
    var listOfDua: [JSON] = []
    
    var player: AVPlayer?
    var flag: Bool = true
    var url = ""
    var musicIdx: Int = 0
    var musicName: String = ""
    var duration: CMTime = CMTime(value: CMTimeValue(0), timescale: 0)
    var isPlayingOutside = false
    var isCellMusicPlaying = false
    var isphonecallRunning = false
    var isPlaying = true
    var timer = Timer()
    let commandCenter = MPRemoteCommandCenter.shared()
    var shared = SingletonRemotControl.shareAPIdata
    var imgURl: String = ""
    var audio_Name: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventCall()
        eventImgView.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
        self.spiner.isHidden = false
        self.spiner.startAnimating()
        hijriApiChangeDate()
        setupUI()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        let globalStrLang = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if globalStrLang == nil {
            strLang = "عربي"
        } else {
            strLang = globalStrLang!
            tfLang.text = strLang
        }
        shared.eventVC = self
        tfLang.inputView = langPicker
        langPicker.tag = 0
        pickerView.tag = 1
        langPicker.delegate = self
        langPicker.dataSource = self
        tfLang.text = strLang
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        musicViewBackground()
        airplaybtnSet()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.isIdleTimerDisabled = true
        eventCall()
        airplaybtnSet()
        hijriApiChangeDate()
        setupUI()
        let globalStrLang = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if globalStrLang == nil {
            strLang = "عربي"
        } else {
            strLang = globalStrLang!
            tfLang.text = strLang
        }
        eventDuaAPIcall()
        startTimer()
        globalControlerName = "EventVC"
        shared.setupRemoteTransportControls()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIApplication.shared.isIdleTimerDisabled = false
        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        player = nil
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        
        if player?.rate == 0 {
            player?.rate = globalSpeed
            player?.play()
            btnPlay.setImage(UIImage(named: "audio_pause"), for: .normal)
            flag = true
            self.isPlayingOutside = true
            UserDefaults.standard.setValue(true, forKey: "isPlaying")
            eventTableView.reloadData()
        }
        else {
            player?.rate = globalSpeed
            player?.pause()
            btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            flag = false
            self.isPlayingOutside = false
            eventTableView.reloadData()
        }
        
        
    }
    
    
    @IBAction func ButtonForwardSec(_ sender: UIButton) {
      
        playNext()
        
    }
    
    
    @IBAction func ButtonGoToBackSec(_ sender: UIButton) {
       
        playBack()
        
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        
        pickerView.isHidden = false
        
    }
    
    
    
    
    
  func musicViewBackground(){
        musicView.backgroundColor = .lightGray
        musicView.layer.cornerRadius = 10
        musicView.clipsToBounds = true
        musicView.layer.borderWidth = 1
        musicView.layer.borderColor = UIColor.black.cgColor
    }
    
    func airplaybtnSet(){
        let buttonView  = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let routerPickerView =  AVRoutePickerView(frame: buttonView.bounds)
         routerPickerView.tintColor = UIColor.white
         routerPickerView.activeTintColor = .white
         buttonView.addSubview(routerPickerView)
         self.customAirPlayView.addSubview(buttonView)
      }
   
   
    
    func fetchMusicUrl(dualist: [JSON], musicIdx: Int){
        
        DispatchQueue.main.async { [self] in
            if dualist != nil {
                if self.musicIdx >= dualist.count {
                    self.musicIdx = 0
                    url = dualist[self.musicIdx]["file"].stringValue as? String ?? ""
                    musicName = dualist[self.musicIdx]["name"].stringValue as? String ?? ""
                    setupMusicUI(url: url, txtLng: musicName)
                }
                else {
                    url = dualist[self.musicIdx]["file"].stringValue as? String ?? ""
                    musicName = dualist[self.musicIdx]["name"].stringValue as? String ?? ""
                    setupMusicUI(url: url, txtLng: musicName)
                }
                
            }
            else {
                
                AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
            }
        }
        
        
    }
    
    
    func setupMusicUI(url: String, txtLng: String) {
        var fetchUrl = url
        guard let playUrl = URL(string: fetchUrl) else { return }
        let playItem: AVPlayerItem = AVPlayerItem(url: playUrl)
        player = AVPlayer(playerItem: playItem)
        player?.playImmediately(atRate: globalSpeed)
        audio_Name = txtLng
        lblMusicTitle.text = txtLng
        self.isPlayingOutside = true
        btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
        eventTableView.reloadData()
        self.spiner.isHidden = true
        self.spiner.stopAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playItem)
        
      
        playbackSlider.minimumValue = globalSpeed
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        duration = playItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        guard let currentTime = player?.currentItem?.currentTime() else { return }
        let duration1 : CMTime = playItem.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        lblMusicDuration.text = self.stringFromTimeInterval(interval: seconds1)
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor.white
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
            if self.player?.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider.value = Float ( time );
                
                shared.updateNowPlayingInfo(strTitle: txtLng, duration: duration, playbackTime: time)
                
                var reverseTime = CMTimeGetSeconds(duration) - time
                self.lblMusicDuration.text = self.stringFromTimeInterval(interval: reverseTime)
            }
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
                self.btnPlay.isHidden = false
            } else {
                print("Buffering completed")
                self.btnPlay.isHidden = false
            }
            
        }
        
    }
    
   
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
            playNext()
        }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
    func playNext(){
        
        DispatchQueue.main.async { [self] in
            self.musicIdx += 1
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            self.isPlayingOutside = true
            fetchMusicUrl(dualist: listOfDua, musicIdx: musicIdx)
        }
        
    }
    
    func playBack(){
        DispatchQueue.main.async { [self] in
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            self.musicIdx -= 1
            if musicIdx >= 0 {
                self.isPlayingOutside = true
                fetchMusicUrl(dualist: listOfDua, musicIdx: musicIdx)
            } else {
                self.musicIdx = 0
                self.isPlayingOutside = true
                fetchMusicUrl(dualist: listOfDua, musicIdx: musicIdx)
            }
        }
        
    }

}

extension EventVC {
    
    func setupUI() {
        UIView.animate(withDuration: 10, delay: 0.01, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            var marqueeStyle = DefaultStyle()
            marqueeStyle.showFullText = true
            self.floatingLbl.style  = marqueeStyle
            self.floatingLbl.textColor = .white
            self.floatingLbl.font = .preferredFont(forTextStyle: .title1)
            print(DailyDuaVC.globalFloatinglable!)
            self.floatingLbl.text =  DailyDuaVC.globalFloatinglable
        }, completion:  { _ in
            
        })
    }
    
    func hijriApi(day: Int){
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
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: changeColor], range: range)
                self.lblHijri.attributedText = attributedString
            }
            
        }, onError: { message in
            print(message as Any)
        })
        
    }
    
    
    func hijriApiChangeDate(){
        updateDay = UserDefaults.standard.integer(forKey: "UpdateDate")
        if updateDay == nil || updateDay == 0 {
            
            hijriApi(day: 0)
            
        } else {
            
            hijriApi(day: updateDay!)
            
        }
        
    }
    
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
    
    //MARK: Event Name and Img API call
    
    func eventCall(){
        
        let objSingelton = SingletonApi()
        updateDay = UserDefaults.standard.integer(forKey: "UpdateDate")
        let timeZone = TimeZone.current.identifier
        objSingelton.eventAPIcall(day: updateDay!, timeZone: timeZone, onSuccess: { response in
        
            DispatchQueue.main.async {
                self.eventName = response["event_name"].stringValue
                self.imgURl = response["title_banner_image"]["url"].stringValue
            }
                
        }, onError: { message in
            print(message as Any)
        })
        
        
    }
    
    
    
    //MARK: EventDua Api call
    func eventDuaAPIcall() {
        let objSingelton = SingletonApi()
        updateDay = UserDefaults.standard.integer(forKey: "UpdateDate")
        let timeZone = TimeZone.current.identifier
        objSingelton.eventAPIcall(day: updateDay!, timeZone: timeZone, onSuccess: { response in
        print(response)
            DispatchQueue.main.async {
    
            var strLng = UserDefaults.standard.string(forKey: "GlobalStrLang")
     
            if strLng == "عربي" {
                
                if  !(response["arabic_dua"].arrayValue.isEmpty ){
                    self.arabicDuaList = response["arabic_dua"].arrayValue
                    self.listOfDua = self.arabicDuaList
                    self.eventTableView.reloadData()
                    self.eventImgView.isHidden = true
                    self.fetchMusicUrl(dualist: self.arabicDuaList, musicIdx: self.musicIdx)
                } else {
                    self.imgCheck()
                }
            }
            else if strLng == "English" {
                if  !(response["english_dua"].arrayValue.isEmpty){
                    self.englishduaList = response["english_dua"].arrayValue
                    self.listOfDua = self.englishduaList
                    self.eventTableView.reloadData()
                    self.eventImgView.isHidden = true
                    self.fetchMusicUrl(dualist: self.englishduaList, musicIdx: self.musicIdx)
                } else {
                    self.imgCheck()
                }
                
            }
            else if strLng == "हिंदी" {
                if  !(response["hindi_dua"].arrayValue.isEmpty){
                    self.hindiduaList = response["hindi_dua"].arrayValue
                    self.listOfDua = self.hindiduaList
                    self.eventTableView.reloadData()
                    self.eventImgView.isHidden = true
                    self.fetchMusicUrl(dualist: self.hindiduaList, musicIdx: self.musicIdx)
                } else {
                    self.imgCheck()
                }
                
            }
            else if strLng == "ગુજરાતી" {
                if  !(response["gujrati_dua"].arrayValue.isEmpty){
                    self.gujratiduaList = response["gujrati_dua"].arrayValue
                    self.listOfDua = self.gujratiduaList
                    self.eventTableView.reloadData()
                    self.eventImgView.isHidden = true
                    self.fetchMusicUrl(dualist: self.gujratiduaList, musicIdx: self.musicIdx)
                } else {
                    self.imgCheck()
                }
            }
            }
        }, onError: { message in
            print(message as Any)
        })
        
        
    }
    
    
    
}

//MARK: Tableview API call
extension EventVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
           return 1
        }
        else {
            
            if strLang == "عربي" {
                return arabicDuaList.count
            }
            else if strLang == "English" {
                return englishduaList.count
            }
            else if strLang == "हिंदी" {
                return hindiduaList.count
            }
            else {
                return gujratiduaList.count
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventAzanTVCell", for: indexPath) as! EventAzanTVCell
        
            cell.fajrTime.text = fajrTm
            cell.sunriseTime.text = sunriseTm
            cell.dhuhrTime.text = dhuhrTm
            cell.sunsetTime.text = sunsetTm
            cell.maghribTime.text = maghribTm
            
            cell.lblLiveEventName.text = self.eventName
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTVCell", for: indexPath) as! EventTVCell
            
            if strLang == "عربي" {
                cell.eventTitle.text = arabicDuaList[indexPath.row]["name"].stringValue
                cell.eventDuration.text = arabicDuaList[indexPath.row]["duration"].stringValue
            }
            else if strLang == "English" {
                cell.eventTitle.text = englishduaList[indexPath.row]["name"].stringValue
                cell.eventDuration.text = englishduaList[indexPath.row]["duration"].stringValue
                
            }
            else if strLang == "हिंदी" {
                cell.eventTitle.text = hindiduaList[indexPath.row]["name"].stringValue
                cell.eventDuration.text = hindiduaList[indexPath.row]["duration"].stringValue
                
            }
            else {
                cell.eventTitle.text = gujratiduaList[indexPath.row]["name"].stringValue
                cell.eventDuration.text = gujratiduaList[indexPath.row]["duration"].stringValue
            }
            cell.btnPlay.tag = indexPath.row
            if musicIdx == indexPath.row {
                if isPlayingOutside == true {
                    cell.btnPlay.setImage(UIImage(named: "pause"), for: .normal)
                } else {
                    cell.btnPlay.setImage(UIImage(named: "play"), for: .normal)
                }
            }
            else {
                cell.btnPlay.setImage(UIImage(named: "play"), for: .normal)
            }
            cell.btnPlay.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 120
        }
        else {
            return 110
        }
    }
    
    

    
    @objc func playCellMusic(_ sender:UIButton){
        
        var isPlay = true
        if isPlayingOutside == true{
            let tag = sender.tag as? Int ?? 0
            musicIdx = tag
            let idx = IndexPath(row: tag, section: 0)
            let cell = eventTableView.cellForRow(at: idx) as! EventTVCell
            cell.btnPlay.setImage(UIImage(named: "play"), for: .normal)
            isPlayingOutside = false
            btnPlay.setImage(UIImage(named: "audio_play"), for:UIControl.State.normal)
            player?.pause()
            print("play")
            
        }
        else {
            let tag = sender.tag as? Int ?? 0
            musicIdx = tag
            let idx = IndexPath(row: tag, section: 0)
            let cell = eventTableView.cellForRow(at: idx) as! EventTVCell
            spiner.isHidden = false
            spiner.startAnimating()
            fetchMusicUrl(dualist: listOfDua, musicIdx: musicIdx)
            print("play")
        }
        
    }
    
}




//MARK: Pickerview
extension EventVC: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return arrLang[row]
        }else {
            return audioSpeed[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return arrLang.count
        }else{
            return audioSpeed.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.selectRow(2, inComponent: 0, animated: true)
        if pickerView.tag == 0 {
            strLang = arrLang[row]
            let langSender = strLang
            if langSender == "" {
                UserDefaults.standard.setValue("عربي", forKey: "GlobalStrLang")
            }
            else {
                UserDefaults.standard.setValue(langSender, forKey: "GlobalStrLang")
            }
            eventDuaAPIcall()
            tfLang.text = strLang
            eventTableView.reloadData()
            tfLang.resignFirstResponder()
            spiner.isHidden = false
            spiner.startAnimating()
        }
        
        else {
            switch row{
            case 0:
                speed = 0.50
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            case 1:
                speed = 0.75
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            case 2:
                speed = 1.0
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            case 3:
                speed = 1.25
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            case 4:
                speed = 1.50
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            case 5 :
                speed = 1.75
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            case 6:
                speed = 2.0
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            case 7:
                speed = 4.0
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
            default:
                break
            }
            
        }
        
    }
    
    
}
extension EventVC {
    
    //MARK: Phone call check
   
    // MARK: -  Timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
    }
   
    
    @objc func refreshData() {
        checkPhoneCall()
    }
   
    func checkPhoneCall() {
        print("is on call",isOnPhoneCall())
        switch isOnPhoneCall()
        {
        case true:
            print("carplay on phone call")
            if player?.timeControlStatus == .playing{
                player?.pause()
                isphonecallRunning = true
            }
        case false:
            print("carplay no phone call")
            if isphonecallRunning{
                if isPlaying {
                    if flag == true {
                        player?.play()
                    } else {
                        player?.pause()
                    }
                } else {
                    player?.pause()
                }
            }
        default: break
            print("done")
        }
    }
  
  private func isOnPhoneCall() -> Bool
    {
        let callCntr = CTCallCenter()
        if let calls = callCntr.currentCalls
        {
            for call in calls
            {
                if call.callState == CTCallStateConnected || call.callState == CTCallStateDialing || call.callState == CTCallStateIncoming
                {
                    print("In call")
                    return true
                }
            }
        }
        print("No calls")
        return false
    }
    
}

extension EventVC {
    func imgCheck(){
        eventImgView.isHidden = false
        player?.rate = 0.0
        player?.pause()
        player = nil
        lblMusicTitle.text = ""
        lblMusicDuration.text = ""
        playbackSlider.value = 0.0
        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        self.isPlayingOutside = false
        eventTableView.reloadData()
        eventImgView.sd_setImage(with: URL(string: imgURl))
        
    }
    
  
}



