//
//  DailyDuaVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON
import AVFoundation
import MarqueeLabel
import SystemConfiguration
import CoreTelephony
import MediaPlayer
import AVKit
import UserNotifications
import FirebaseMessaging
import Alamofire
import CoreLocation

var globalName: String = ""
var audio_Url = "https://mydua.online/aamaal-and-namaz/"
class DailyDuaVC: UIViewController {
    
    @IBOutlet weak var dailyDuaTableView: UITableView!
    @IBOutlet weak var lblHijri: UILabel!
    @IBOutlet weak var floatingLbl: MarqueeLabel!
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var audioLbl: UILabel!
    @IBOutlet weak var lblcurrentText: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var tfLang: UITextField!
    @IBOutlet weak var customAirPlayView: UIView!
   
    let langPicker = UIPickerView()
    var arrLang = ["عربي","English","हिंदी","ગુજરાતી"]
    let dailyDuaCellHeight = 90.0
    var defultDuaList : [JSON] = []
    var floatLabelList : [JSON] = []
    var player: AVPlayer?
    var players: AVAudioPlayer?
    var playerItem: AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    let audioSpeed = ["0.5x", "0.75x", "normal", "1.25x", "1.5x", "1.75x", "2x", "4x"]
    var speed:Float = 1
    var strLang = "عربي"
    var isTapSound = true
    var audioUrl = ""
    var musicIdx = 0
    var isPlayingOutside = false
    var isCellMusicPlaying = false
    let objSingleton = SingletonApi()
    static var globalFloatinglable: String!
    var flag: Bool = true
    let volumeView = MPVolumeView()
    var duration: CMTime = CMTime(value: CMTimeValue(0), timescale: 0)
    static var timezone: String? = ""
    let commandCenter = MPRemoteCommandCenter.shared()
    var shared = SingletonRemotControl.shareAPIdata
    var updateDay: Int?
    var playIndex: Int = 0
    var audio_Name: String?
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    var azanTime: [AzanTime] = []
    var duaDay: String?
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getLoacation()
        //shared.updateNowPlayingInfo(strTitle: "", duration: CMTime(value: CMTimeValue(0), timescale: 0), playbackTime: 0)
        UIApplication.shared.isIdleTimerDisabled = true
        hijriApiChangeDate()
        let tokens_Id = Messaging.messaging().fcmToken
        UserDefaults.standard.set(tokens_Id, forKey: "TokenID")
        let objSingleton = SingletonApi()
        objSingleton.submitTokenIDTimeZoneAPI()
        self.checkForLatestVersion()
//        shared.player = self.player
        musicIdx = 0
        dailyDuaTableView.dataSource = self
        dailyDuaTableView.delegate = self
        globalControlerName = "DailyDuaVC"
        startTimer()
        let globalStrLang = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if globalStrLang == nil {
            strLang = "عربي"
        } else {
            strLang = globalStrLang!
            tfLang.text = strLang
        }
        modeCheck()
        fetchFloatLabel()
        musicViewBackground()
        fetchFloatLabel()
        operationQue()
      
        fetchMusicUrl(with: musicIdx)
        shared.setupRemoteTransportControls()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DailyDuaVC.timezone = TimeZone.current.identifier
       // hijriApi()
        hijriApiChangeDate()
        UIApplication.shared.isIdleTimerDisabled = true
        
        let globalStrLang = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if globalStrLang == nil {
            strLang = "عربي"
        } else {
            strLang = globalStrLang!
            tfLang.text = strLang
        }
        shared.dailyDuaVC = self
        view.addSubview(volumeView)
        self.spiner.isHidden = false
        spiner.startAnimating()
        fetchFloatLabel()
        setupUI()
        operationQue()
        fetchMusicUrl()
        startTimer()
        tfLang.inputView = langPicker
        langPicker.tag = 0
        pickerView.tag = 1
        langPicker.delegate = self
        langPicker.dataSource = self
        tfLang.text = strLang
        pickerView.delegate = self
        pickerView.dataSource = self
        tfLang.delegate = self
        pickerView.isHidden = true
        musicViewBackground()
        airplaybtnSet()
        getLoacation()
    }
    
        
    func airplaybtnSet(){
        let buttonView  = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let routerPickerView =  AVRoutePickerView(frame: buttonView.bounds)
         routerPickerView.tintColor = UIColor.white
         routerPickerView.activeTintColor = .white
         buttonView.addSubview(routerPickerView)
         self.customAirPlayView.addSubview(buttonView)
      }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
            lblHijri.backgroundColor = .black
//            dayLbl.backgroundColor = .black
//            dayLbl.textColor = .white
            dailyDuaTableView.reloadData()
        } else {
            overrideUserInterfaceStyle = .light
            lblHijri.backgroundColor = .white
//            dayLbl.backgroundColor = .white
//            dayLbl.textColor = .black
            dailyDuaTableView.reloadData()
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
       // player?.pause()
        ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        player = nil
    }
    

    private func musicViewBackground(){
        musicView.backgroundColor = .lightGray
        musicView.layer.cornerRadius = 10
        musicView.clipsToBounds = true
        musicView.layer.borderWidth = 1
        musicView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func operationQue(){
        let op = BlockOperation()
        op.addExecutionBlock {
            self.fetchFloatLabel()
        }
        let op1 = BlockOperation()
        op1.addExecutionBlock {
        }
        op1.addDependency(op)
        let que = OperationQueue()
        que.addOperations([op,op1], waitUntilFinished: true)
    }
    @IBAction func ButtonPlay(_ sender: Any) {
        print(audio_Url)
        if player?.rate == 0
        {
            self.isPlayingOutside = true
            print(speed)
            player?.rate = globalSpeed
            player?.play()
            flag = true
            ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
            UserDefaults.standard.setValue(true, forKey: "isPlaying")
//            ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
            dailyDuaTableView.reloadData()
        } else {
            player?.rate = globalSpeed
            player?.pause()
            ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            self.isPlayingOutside = false
            flag = false
            dailyDuaTableView.reloadData()
        }
    }
    
    @IBAction func ButtonGoToBackSec(_ sender: Any) {
        playBack()
    }
    
    @IBAction func ButtonForwardSec(_ sender: Any) {
        playNext()
    }
        
    @IBAction func settingsTapped(_ sender: Any) {
        pickerView.isHidden = false
    }

    //MARK: Phone call check
    var isphonecallRunning = false
    var isPlaying = true

    // MARK: -  Timer
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
    }
   
    var timer = Timer()
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

//MARK: - TableView Methods
extension DailyDuaVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else  {
            
            return defultDuaList.count
            
        }
       
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = dailyDuaTableView.dequeueReusableCell(withIdentifier: "DailyDuaAzanTVCell", for: indexPath) as! DailyDuaAzanTVCell
            
            cell.day_Lbl.text = duaDay
            cell.fajrTime.text = fajrTm
            cell.sunriseTime.text = sunriseTm
            cell.dhuhrTime.text = dhuhrTm
            cell.sunsetTime.text = sunsetTm
            cell.maghribTime.text = maghribTm
            
            
            cell.selectionStyle = .none
           
            return cell
           
            
        }
        else {
            if let cell = dailyDuaTableView.dequeueReusableCell(withIdentifier: "DailyDuaTableViewCell", for: indexPath) as? DailyDuaTableViewCell {
                if traitCollection.userInterfaceStyle == .dark{
                    cell.sepratorView.layer.borderColor = UIColor.white.cgColor
                }else{
                    cell.sepratorView.layer.borderColor = UIColor.black.cgColor
                }
                cell.titleLbl.text = defultDuaList[indexPath.row]["name"].stringValue
                cell.playButton.tag = indexPath.row
                if musicIdx == indexPath.row{
                    if isPlayingOutside == true{
                        cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }else{
                        cell.playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                }
                else{
                    cell.playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                }
                cell.playButton.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                cell.audioUrl = defultDuaList[indexPath.row]["file"].stringValue
                cell.durationLbl.text = defultDuaList[indexPath.row]["duration"].stringValue
                cell.selectionStyle = .none
                return cell
            }

        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = storyboard?.instantiateViewController(withIdentifier: "AudioDetailVC") as? AudioDetailVC {
            
            cell.audioLbl = defultDuaList[indexPath.row]["audio"]["title"].stringValue
            audio_Url = defultDuaList[indexPath.row]["audio"]["url"].stringValue
            cell.audioUrl = defultDuaList[indexPath.row]["audio"]["url"].stringValue
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return dailyDuaCellHeight
        if indexPath.section == 0 {
            
            return 120
            
        }
        else {
            
            return UITableView.automaticDimension
            
        }
    }
    
    
    
    @objc func playCellMusic(_ sender:UIButton){
        var isPlay = true
        if isPlayingOutside == true{
            let tag = sender.tag as? Int ?? 0
            musicIdx = tag
            let idx = IndexPath(row: tag, section: 0)
            let cell = dailyDuaTableView.cellForRow(at: idx) as! DailyDuaTableViewCell
            cell.playButton.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            isPlayingOutside = false
            ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            player?.pause()
        }
        else{
            let tag = sender.tag as? Int ?? 0
            musicIdx = tag
            UserDefaults.standard.set(musicIdx, forKey: "DailyDuaIndex")
            let idx = IndexPath(row: tag, section: 0)
            let cell = dailyDuaTableView.cellForRow(at: idx) as! DailyDuaTableViewCell
            spiner.isHidden = false
            spiner.startAnimating()
            fetchMusicUrl(with: musicIdx,and: cell)
           // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            isPlayingOutside = true
           // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
            
        }
    }
}

extension DailyDuaVC{

    func setupMusicUI(url:String,str:String) {
       var fetchedUrl = url
       guard let url = URL(string: fetchedUrl) else { return }
       let playerItem:AVPlayerItem = AVPlayerItem(url: url)
       player = AVPlayer(playerItem: playerItem)
       let val = UserDefaults.standard.value(forKey: "speedUpadte") as? Float ?? 0.0
       player?.playImmediately(atRate: globalSpeed)
       audio_Name = str
        globalName = str
       dailyDuaTableView.reloadData()
       self.spiner.isHidden = true
       self.spiner.stopAnimating()
       self.isPlayingOutside = true
       self.isCellMusicPlaying = true
       self.audioLbl.text = str
       ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
       //MARK: Add playback slider
       playbackSlider.minimumValue = globalSpeed
       playbackSlider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
       duration = playerItem.asset.duration
       let seconds : Float64 = CMTimeGetSeconds(duration)
    
        guard let currentTime = player?.currentItem?.currentTime() else { return }

       let duration1 : CMTime = playerItem.currentTime()
       let seconds1 : Float64 = CMTimeGetSeconds(duration1)
       lblcurrentText.text = self.stringFromTimeInterval(interval: seconds1)
       playbackSlider.maximumValue = Float(seconds)
       playbackSlider.isContinuous = true
       playbackSlider.tintColor = UIColor.white
       player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
           if self.player?.currentItem?.status == .readyToPlay {
               let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
               self.playbackSlider.value = Float ( time );
               
               shared.updateNowPlayingInfo(strTitle: str, duration: duration, playbackTime: time)
               
               var reverseTime = CMTimeGetSeconds(duration) - time
               self.lblcurrentText.text = self.stringFromTimeInterval(interval: reverseTime)
           }
           let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
           if playbackLikelyToKeepUp == false{
               print("IsBuffering")
               self.ButtonPlay.isHidden = false
           } else {
               //stop the activity indicator
               print("Buffering completed")
               self.ButtonPlay.isHidden = false
           }
           
       }
   }
    
   
    func fetchMusicUrl() {
        // Daily Dua API Call
        var url = ""
        let objSingleton = SingletonApi()
        objSingleton.dailyDuaListAPI(onSuccess: {response in
            print("Got Respose")
            print(response)
            DispatchQueue.main.async {
                if !(response.isEmpty){
                    if self.strLang == "English"{
                         url = response["english_dua"].arrayValue[self.musicIdx]["file"].stringValue
                        let txt  = response["english_dua"].arrayValue[self.musicIdx]["name"].stringValue as? String ?? ""
                        self.setupMusicUI(url: url,str:txt)
                        print(self.defultDuaList)
                    }
                    else if self.strLang == "हिंदी"{
                        url = response["hindi_dua"].arrayValue[self.musicIdx]["file"].stringValue
                        let txt  = response["hindi_dua"].arrayValue[self.musicIdx]["name"].stringValue as? String ?? ""
                        self.setupMusicUI(url: url,str:txt)
                    }else if self.strLang == "عربي"{
                        url = response["arabic_dua"].arrayValue[self.musicIdx]["file"].stringValue
                        let txt  = response["arabic_dua"].arrayValue[self.musicIdx]["name"].stringValue as? String ?? ""
                        self.setupMusicUI(url: url,str:txt)
                    }else{
                        url = response["gujrati_dua"].arrayValue[self.musicIdx]["file"].stringValue
                        let txt  = response["gujrati_dua"].arrayValue[self.musicIdx]["name"].stringValue as? String ?? ""
                        self.setupMusicUI(url: url,str:txt)
                    }
                
                } else {
                    AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
                }
            }
        }, onError: { message in
            print(message as Any)
        }
        )
       
    }
    func fetchMusicUrl(with idx:Int) {
        // Daily Dua API Call
        var url = ""
        let objSingleton = SingletonApi()
        objSingleton.dailyDuaListAPI(onSuccess: {response in
            print("Got Respose")
            print(response)
            print(response[0]["english_dua"].count)
            UserDefaults.standard.set(idx, forKey: "DailyDuaIndex")
            DispatchQueue.main.async {
                if response != nil {
                      
                    if self.strLang == "English"{
                        var arrdua = response[0]["english_dua"].arrayValue
                        print(arrdua.count)
                        if idx<arrdua.count{
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            let txt  = arrdua[idx]["audio"]["title"].stringValue as? String ?? ""
                            self.setupMusicUI(url: url, str: txt)
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }
                                             
                    }
                    else if self.strLang == "हिंदी"{
                        var arrdua = response["hindi_dua"].arrayValue
                        if idx<arrdua.count-1{
                            url = arrdua[idx]["file"].stringValue
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                            self.setupMusicUI(url: url, str: txt)
                            self.audioLbl.text = txt
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }
                        
                    }
                    else if self.strLang == "عربي"{
                        var arrdua = response["arabic_dua"].arrayValue
                        if idx<arrdua.count-1{
                            url = arrdua[idx]["file"].stringValue
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                            self.setupMusicUI(url: url, str: txt)
                            self.audioLbl.text = txt
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }


                    }else{
                        var arrdua = response[0]["gujarati_dua"].arrayValue
                        if idx<arrdua.count-1{
                            url = arrdua[idx]["file"].stringValue
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                            self.setupMusicUI(url: url, str: txt)
                            self.audioLbl.text = txt
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }


                    }


                } else {
                    AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
                }
            }
        }, onError: { message in
            print(message as Any)
        }
        )
    
    }
    func fetchMusicUrl(with idx:Int,and cell:DailyDuaTableViewCell) {
        // Daily Dua API Call
        var url = ""
        let objSingleton = SingletonApi()
        objSingleton.dailyDuaListAPI(onSuccess: {response in
            print("Got Respose")
            print(response)
           
            DispatchQueue.main.async {
                if response != nil {
                    
                    if self.strLang == "English"{
                        var arrdua = response["english_dua"].arrayValue
                        print(arrdua.count)
                        if idx<arrdua.count{
                            
                            if self.isPlayingOutside == true{
                                self.isCellMusicPlaying = true
                                self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                self.isCellMusicPlaying = true
                                cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                                self.setupMusicUI(url: arrdua[idx]["file"].stringValue, str: txt)
                                self.audioLbl.text = txt
                                self.dailyDuaTableView.reloadData()
                                self.spiner.isHidden = true
                                self.spiner.stopAnimating()
                                
                            }
                            

                            else if self.isPlayingOutside == false{
                                self.isCellMusicPlaying = true
                                self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                self.isCellMusicPlaying = true
                                cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                                self.setupMusicUI(url: arrdua[idx]["file"].stringValue, str: txt)
                                self.audioLbl.text = txt
                                self.dailyDuaTableView.reloadData()
                                self.spiner.isHidden = true
                                self.spiner.stopAnimating()
                            }
                           
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }

                    }
                    else if self.strLang == "हिंदी"{
                        var arrdua = response["hindi_dua"].arrayValue
                        if idx<arrdua.count-1{
                            url = arrdua[idx]["file"].stringValue
                    
                            cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                            self.setupMusicUI(url: arrdua[idx]["file"].stringValue, str: txt)
                            self.audioLbl.text = txt
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }
                        
                        
                    }
                    else if self.strLang == "عربي"{
                        var arrdua = response["arabic_dua"].arrayValue
                        if idx<arrdua.count-1{
                            url = arrdua[idx]["file"].stringValue
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                            self.setupMusicUI(url: arrdua[idx]["file"].stringValue, str: txt)
                            self.audioLbl.text = txt
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }


                    }else{
                        var arrdua = response["gujarati_dua"].arrayValue
                        if idx<arrdua.count-1{
                            url = arrdua[idx]["file"].stringValue
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            let txt  = arrdua[idx]["name"].stringValue as? String ?? ""
                            self.setupMusicUI(url: arrdua[idx]["file"].stringValue, str: txt)
                            self.audioLbl.text = txt
                        }
                        else{
                            self.musicIdx = arrdua.count-1
                            print("no")
                        }


                    }


                } else {
                    AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
                }
            }
        }, onError: { message in
            print(message as Any)
        }
        )
       
    }
    
}


extension DailyDuaVC{
    func startMarqueeAnimation() {
        UIView.transition(with: self.floatingLbl,
                          duration:10.0,
                       options: .transitionCrossDissolve,
                    animations: { [weak self] in
            self?.floatingLbl.frame.origin.x = -(self!.floatingLbl.frame.width)
                 }, completion: nil)
        
        
       }
    func setupUI() {
        UIView.animate(withDuration: 10, delay: 0.01, options: ([.curveLinear, .repeat]), animations: {() -> Void in            
            var marqueeStyle = DefaultStyle()
            marqueeStyle.showFullText = true
            self.floatingLbl.style  = marqueeStyle
            self.floatingLbl.textColor = .white
            self.floatingLbl.font = .preferredFont(forTextStyle: .title1)
            self.floatingLbl.text = "The loss that causes illness or burns the heart is the loss of the loved ones.  Imam ali ( a.s)        Request to recite a Surah Fateha for         Marhoom Haji Ramzan Ali Fazal Ali Halani        Marhoom Al Haj Shabbirali  Dost Mohammad Mukadam        Kul momineen and mominaat.                સૂરા ફાતેહાનો પાઠ કરવા વિનંતી        મરહૂમ હાજી રમઝાન અલી ફઝલ અલી હાલાની        મરહૂમ અલ હજ શબ્બીરાલી દોસ્ત મોહમ્મદ મુકદમ        અને - કુલ મોમીનીન અને મોમિનાત."
            if let day = UserDefaults.standard.value(forKey: "currentDay") {
                self.duaDay = (day as! String ) + " Dua"
            }
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
                
                //attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: range)
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: changeColor], range: range)
                self.lblHijri.attributedText = attributedString
            }
            
        }, onError: { message in
            print(message as Any)
        })
        
        
        
        /*
        let objSingleton = SingletonApi()
        objSingleton.hijriLabelAPI(onSuccess: { response in
            print(response)
            DispatchQueue.main.async {
                let hijriText = response["hijri_date"].stringValue //hijri_date_show
                var testText = response["event"].stringValue
                
                if testText == "" {
                    testText = testText
                } else {
                    testText = "(\(testText))"
                }
                //MARK: make attributedString
                var attributedString = NSMutableAttributedString(string: "\(hijriText) \n \(testText)")
                let range = NSString(string: "\(hijriText) \n \(testText)").range(of: "\(testText)", options: String.CompareOptions.caseInsensitive)
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: range)
                self.lblHijri.attributedText = attributedString
            }
        }, onError: { message in
            print(message as Any)
        })
         */
    }
    
    
    // MARK: fatch floting label
    func fetchFloatLabel() {
        // Daily Dua API Call
        let objSingleton = SingletonApi()
        objSingleton.dailyDuaListAPI(onSuccess: {response in
            print("Got Respose")
            print(response)
            DispatchQueue.main.async {
                if response != nil {
                    if self.strLang == "English"{
                        self.defultDuaList = response["english_dua"].arrayValue
                        
                        audio_Url = self.defultDuaList[0]["file"].stringValue as? String ?? ""
                        self.audioUrl = audio_Url
                        print(self.defultDuaList)
                        self.dailyDuaTableView.reloadData()
                    }
                    else if self.strLang == "عربي"{
                        self.defultDuaList = response["arabic_dua"].arrayValue
                        print(self.defultDuaList)
                        audio_Url = self.defultDuaList[0]["file"].stringValue
                        self.dailyDuaTableView.reloadData()
                    }
                    else if self.strLang == "हिंदी"{
                        self.defultDuaList = response["hindi_dua"].arrayValue
                        print(self.defultDuaList)
                        audio_Url = self.defultDuaList[0]["file"].stringValue
                        self.dailyDuaTableView.reloadData()
                    }else{
                        self.defultDuaList = response["gujrati_dua"].arrayValue
                        print(self.defultDuaList)
                        audio_Url = self.defultDuaList[0]["file"].stringValue
                        self.dailyDuaTableView.reloadData()
                    }
                    self.spiner.stopAnimating()
                    self.spiner.isHidden = true

                } else {
                    self.spiner.stopAnimating()
                    self.spiner.isHidden = true
                    AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
                }
            }
        }, onError: { message in
            print(message as Any)
        }
        )

        objSingleton.floatLabelAPI(onSuccess: { response in
            print(response)
            DispatchQueue.main.async {
               self.floatLabelList = response["message"]["animatedtext"].arrayValue
                //self.floatingLbl.text = response["message"]["animatedtext"][0]["heading"].stringValue
                var strFinalVal = ""
               // print(self.floatLabelList)
                var removeWord = "</b>"
                for element in self.floatLabelList {
                    print(element)
                    
                    strFinalVal = strFinalVal + "        " + element["heading"].stringValue
                }
                print(strFinalVal)
                let outputString = self.removeHTMLTags(strFinalVal)
                self.floatingLbl.text = outputString
                DailyDuaVC.globalFloatinglable = outputString
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    func removeHTMLTags(_ input: String) -> String {
        // Define the HTML tags to be removed
        let tags = ["<b>", "\\/", "<\\/b>","</b>","/","&nbsp;"]

        // Create a regular expression pattern to match the tags
        let pattern = tags.map { NSRegularExpression.escapedPattern(for: $0) }.joined(separator: "|")
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        // Replace the matched tags with an empty string
        let range = NSRange(location: 0, length: input.utf16.count)
        let result = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: " ")

        return result
    }
    
    
}

extension DailyDuaVC: MarqueeLabelProtocol {
    func tap(sender: MarqueeLabel) {
        if let text = sender.text {
            print(text)
        }
    }
}
extension DailyDuaVC{
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player?.seek(to: targetTime)
        
        if player?.rate == 0
        {
            player?.play()
        }
    }
    
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
            // Automatically play the next track when the current track finishes
            playNext()
        }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

}


extension DailyDuaVC: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: - Picker Delegate
    
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
        if pickerView.tag == 0{
            self.musicIdx = 0
            strLang = arrLang[row]
            let langSender = strLang
            if langSender == "" {
            UserDefaults.standard.setValue("عربي", forKey: "GlobalStrLang")
            } else {
            UserDefaults.standard.setValue(langSender, forKey: "GlobalStrLang")
            }
            tfLang.text = strLang
            fetchFloatLabel()
            fetchMusicUrl()
            tfLang.resignFirstResponder()
            spiner.isHidden = false
            spiner.startAnimating()
        }else{
            switch row{
            case 0:
                speed = 0.50
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 1:
                speed = 0.75
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 2:
                speed = 1.0
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 3:
                speed = 1.25
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 4:
                speed = 1.50
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 5 :
                speed = 1.75
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 6:
                speed = 2.0
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 7:
                speed = 4.0
                globalSpeed = speed
                UserDefaults.standard.setValue(speed, forKey: "speedUpadte")
                NotificationCenter.default.post(name: NSNotification.Name("speedUpadte"), object: nil, userInfo: ["Speed":speed])
                player?.rate = speed
                pickerView.isHidden = true
            default:
                break
            }
//            UserDefaults.standard.setValue(speed, forKey: "")
        }
    }
    
    
}
extension DailyDuaVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension DailyDuaVC {
    
    func playNext(){
        DispatchQueue.main.async { [self] in
            print(musicIdx)
            self.musicIdx += 1
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            self.isTapSound = true
            self.isPlayingOutside = true
            print(musicIdx)
            self.fetchMusicUrl(with: self.musicIdx)
        }
    }
 
    
    func playBack(){
        DispatchQueue.main.async {
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            self.musicIdx -= 1
            if self.musicIdx >= 0{
                self.isTapSound = true
                self.isPlayingOutside = true
                self.fetchMusicUrl(with: self.musicIdx)
            }else{
                self.isPlayingOutside = true
                self.isTapSound = true
                self.musicIdx = 0
                print("Less than Zero")
            }
            
        }
    }
    
    
}

extension DailyDuaVC {
    
    /*
    func updateNowPlayingInfo(strTitle: String) {
        var nowPlayingInfo = [String: Any]()

        // Set the title
        nowPlayingInfo[MPMediaItemPropertyTitle] = strTitle

        // Set the current playback time
        if let currentTime = player?.currentItem?.currentTime() {
            let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTimeInSeconds
        }

        // Set the playback rate
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

        // Set the now playing info
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    func setupRemoteTransportControls() {
        commandCenter.playCommand.addTarget { [unowned self] event in
                self.player?.rate = globalSpeed
                self.player?.play()
                self.isPlayingOutside = true
                self.ButtonPlay.isHidden = true
                flag = true
                ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                dailyDuaTableView.reloadData()
                return .success
                return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
                self.player?.rate = globalSpeed
                self.player?.pause()
                ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                self.isPlayingOutside = false
                flag = false
                dailyDuaTableView.reloadData()
                return .success
                return .commandFailed
        }

        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            // Handle next track
            playNext()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            // Handle previous track
            playBack()
            return .success
        }
    }
    
    */
    
    @objc func checkForLatestVersion() {
        
        self.checkForAppVersionOnStore { isUpdateAvailable in
            
            DispatchQueue.main.async {
                
                if  isUpdateAvailable{
                    
                   let alertController = UIAlertController(title: "New App Version", message: "Do you want to download this version?", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Yes", style: .default,handler: { _ in
                            //https://apps.apple.com/in/app/be-kinder-you/id6450614071
                            if let url = URL(string: "itms-apps://apple.com/us/app/my-dua-online-audio-dua/id6474487002") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }))
                        
                        alertController.addAction(UIAlertAction(title: "No", style: .default,handler: { _ in
                            
                        }))
                        self.present(alertController, animated: true)
                }
            }
            
        }
        
        
    }
    
    func checkForAppVersionOnStore(with completionHandler:@escaping(_ isUpdateAvailable:Bool)->Void) {
        
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            
            completionHandler(false)
            return
        }
        print(url.absoluteString)
        let header = HTTPHeaders.init(["Content-Type" : "application/json"])
        AF.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            switch response.result {
                
            case .success(let json):
                
                print(json)
                if  let result = json as? [String:Any] {
                    
                    if let resltList = result["results"] as? [[String:Any]], resltList.count > 0 {
                        
                        if let version = resltList[0]["version"] as? String {
                            if version.compare(currentVersion, options: .numeric) == .orderedDescending {
                                print("store version is newer")
                                
                                completionHandler(true)
                                
                            } else {
                                completionHandler(false)

                            }
                        }  else {
                            completionHandler(false)

                        }

                    }  else {
                        completionHandler(false)

                    }
                   
                
                } else {
                    completionHandler(false)

                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
                
                
            }
            
            
        }

        
    }
    
}

extension DailyDuaVC {
    
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
    
    
}

extension DailyDuaVC : CLLocationManagerDelegate {
    
    func getLoacation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            showLocationPermissionDeniedAlert()
        default:
            break
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("Latitude: \(latitude!), Longitude: \(longitude!)")
            let objSingleton = SingletonApi()
            objSingleton.longLatAPIcall(lat: latitude!, lon: longitude!, onSuccess: { [self] response in
                azanTime.removeAll()
                print(response)
                DispatchQueue.main.async { [self] in
                    
                    /*
                    self.azanTime.append(AzanTime(Fajr: (response["Fajr"].stringValue as? String ?? ""),Sunrise: (response["Sunrise"].stringValue as? String ?? ""),Dhuhr: (response["Dhuhr"].stringValue as? String ?? "") ,Sunset: (response["Sunset"].stringValue as? String ?? ""),Maghrib: (response["Maghrib"].stringValue as? String ?? "")))
                    print(azanTime)
                    */
                
                    let fajrTm1 = response["Fajr"].stringValue as? String ?? ""
                    fajrTm = String(fajrTm1.prefix(5))
                    
                    let sunriseTm1 = response["Sunrise"].stringValue as? String ?? ""
                    sunriseTm = String(sunriseTm1.prefix(5))
                    
                    let dhuhrTm1 = response["Dhuhr"].stringValue as? String ?? ""
                    dhuhrTm = String(dhuhrTm1.prefix(5))
                    
                    let sunsetTm1 = response["Sunset"].stringValue as? String ?? ""
                    sunsetTm = String(sunsetTm1.prefix(5))
                    
                    let maghribTm1 = response["Maghrib"].stringValue as? String ?? ""
                    maghribTm = String(maghribTm1.prefix(5))
                    
                    dailyDuaTableView.reloadData()
                }
                
            }, onError: { message in
                    print(message as Any)
            })
            
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    
    func showLocationPermissionDeniedAlert() {
        
        musicPause()
        
        let alertController = UIAlertController(title: "Location Access Denied", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.showLocationPermissionDeniedAlert()
            
        })
        alertController.addAction(cancelAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    func musicPause(){
        player?.rate = globalSpeed
        player?.pause()
        ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        self.isPlayingOutside = false
        flag = false
        dailyDuaTableView.reloadData()
    }
    
}

