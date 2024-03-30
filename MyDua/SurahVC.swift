//
//  SurahVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON
import AVFoundation
import CoreTelephony
import AVKit
import MediaPlayer

class SurahVC: UIViewController {
    @IBOutlet weak var surahTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var surah: UITabBarItem! {
        didSet{
            surah.image = UIImage(named: "surah")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    @IBOutlet weak var floatingLbl: MarqueeLabel!
    @IBOutlet weak var lblHijri: UILabel!
    var floatLabelList : [JSON] = []
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var musicLbl: UILabel!
    @IBOutlet weak var lblcurrentText: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var customAirPlayView: UIView!
    let langPicker = UIPickerView()
    var player: AVPlayer?
    var players: AVAudioPlayer?
    var playerItem: AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    let audioSpeed = ["0.5x", "0.75x", "normal", "1.25x", "1.5x", "1.75x", "2x", "4x"]
    var speed:Float = 1.0
    var isTapSound = true
    var audioUrl = ""
    private var musicIdx = 0
    let surahListCellHeight = 90.0
    let objSingleton = SingletonApi()
    var surahList = [Arabic_surah]()
    var searchArr = [Arabic_surah]()
    var searching : Bool?
    var isPlayingOutside = false
    var isCellMusicPlaying = false
    var flag: Bool = true
    var duration: CMTime = CMTime(value: CMTimeValue(0), timescale: 0)
    var shared = SingletonRemotControl.shareAPIdata
    let commandCenter = MPRemoteCommandCenter.shared()
    var updateDay: Int?
    var audio_Name: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hijriApiChangeDate()
        shared.surahaVC = self
        UIApplication.shared.isIdleTimerDisabled = true
        surahTableView.dataSource = self
        surahTableView.delegate = self
        searchBar.delegate = self
        spiner.isHidden = false
        spiner.startAnimating()
        startTimer()
        setupUI()
        musicDelegate()
        musicViewBackground()
        hide_Keyboard()
        airplaybtnSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hijriApiChangeDate()
        musicIdx = 0
        fetchFavDuaList()
        startTimer()
        globalControlerName = "SurahVC"
        self.navigationController?.isNavigationBarHidden = true
        fetchSurahData()
        modeCheck()
        shared.setupRemoteTransportControls()
        
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        player = nil
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
            searchBar.barTintColor = .black
            surahTableView.reloadData()

        } else {
            overrideUserInterfaceStyle = .light
            lblHijri.backgroundColor = .white
            searchBar.barTintColor = .systemBackground
            surahTableView.reloadData()

        }
    }
    
    //MARK: Keyboard Hide
    func hide_Keyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisKeyboard(){
        view.endEditing(true)
    }
    
    private func musicViewBackground(){
        musicView.backgroundColor = .lightGray
        musicView.layer.cornerRadius = 10
        musicView.clipsToBounds = true
        musicView.layer.borderWidth = 1
        musicView.layer.borderColor = UIColor.black.cgColor
    }
    
    
    @IBAction func ButtonPlay(_ sender: Any) {
        print(audio_Url)
//        setupMusicUI()
        if player?.rate == 0
        {
            player?.rate = globalSpeed
            player?.playImmediately(atRate: globalSpeed)
            self.isPlayingOutside = true
            self.surahTableView.reloadData()
            flag = true
//            self.loadingView.isHidden = false
            ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
        } else {
            player?.rate = globalSpeed
            player?.pause()
            self.isPlayingOutside = false
            flag = false
            self.surahTableView.reloadData()
            ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Phone call check
    
    var timer = Timer()
    var isphonecallRunning = false
    var isPlaying = true
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


//MARK: - TableView Methods
extension SurahVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false) {
            return searchArr.count
           
        } else {
            return surahList.count
          
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = surahTableView.dequeueReusableCell(withIdentifier: "SurahTableViewCell", for: indexPath) as? SurahTableViewCell {
            if traitCollection.userInterfaceStyle == .dark{
                cell.sepratorView.layer.borderColor = UIColor.white.cgColor
            }else{
                cell.sepratorView.layer.borderColor = UIColor.black.cgColor
            }
            if (!(searching ?? false)) {
                cell.playBtn.tag = indexPath.row
                if musicIdx == indexPath.row{
                    if isPlayingOutside == true{
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
    //                    if self.isCellMusicPlaying == true{
    //                        self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
    //                    }
                    }else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                }
                else{
                    cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                }

                let arr  = surahList[indexPath.row]
                if arr.fav == "No"{
                    cell.favourtiteImage.image = UIImage(named: "unFavourite")
                }else{
                    cell.favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green, renderingMode: .alwaysOriginal)
                }
                cell.favourtiteImage.tag = indexPath.row
                cell.favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeFav)))
                cell.duration_Lbl.text = arr.duration ?? ""
                cell.surahTitleLbl.text = arr.name ?? ""
                cell.audioUrl = arr.file ?? ""
                cell.playBtn.tag = indexPath.row
                cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
            } else {
                let searchArr = searchArr[indexPath.row]
                cell.surahTitleLbl.text = searchArr.name ?? ""
                cell.audioUrl = searchArr.file ?? ""
                cell.duration_Lbl.text = searchArr.duration ?? ""
                cell.playBtn.tag = indexPath.row
                cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return surahListCellHeight
        return UITableView.automaticDimension
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty) {
            searchArr = surahList
        } else {
            searchArr = surahList.filter{$0.caption!.contains(searchText.capitalized)}
        }
        searching = true
        surahTableView.reloadData()
        
    }
    @objc func makeFav(_ sender:UITapGestureRecognizer){
        
        spiner.isHidden = false
        spiner.startAnimating()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        let tag = sender.view?.tag as? Int ?? 0
        let arr = surahList[tag]
        print(arr.name)
        if userId != ""{
            objSingleton.makeFavourite(userId: userId, audioId: surahList[tag].id as? Int ?? 0,typeOfAudio: "surahfavaudio"){
                str in
                if str == "success"{
                    self.fetchFavDuaList()
                    //                    self.duaTableView.reloadData()
                }else{
                    print("error")
                }
            }

        }
        else{
            // AlertMessageController.ShowAlert(title: "Error", messgae: "Please Login FIrst", vc: self)
            spiner.isHidden = true
            spiner.stopAnimating()
            let alert = UIAlertController(title: AppName, message: "Please login", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                let signInStoryboard = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(signInStoryboard, animated: true)
            })
            alert.addAction(ok)
            present(alert, animated: true)
        }

    }
    
    @objc func playCellMusic(_ sender:UIButton){
        let tag = sender.tag as? Int ?? 0
        self.spiner.isHidden = false
        self.spiner.startAnimating()
        musicIdx = tag
        fetchMusicUrl(with: musicIdx)
    }
    
}























extension SurahVC{
    func fetchSurahData(){
        self.objSingleton.surah_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.surahList.append(contentsOf: response.arabic_surah ?? [])
                if !self.surahList.isEmpty{
                    if self.musicIdx<self.surahList.count{
                        let txt  = self.surahList[0].name as? String ?? ""
                        self.musicLbl.text = txt
                        self.setupMusicUI(url: self.surahList[self.musicIdx].file as? String ?? "", str: txt)
                    }
                }
                self.surahTableView.reloadData()
                self.spiner.isHidden = true
                self.spiner.stopAnimating()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    
    
    func fetchFavDuaList(){
        self.objSingleton.surah_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.surahList.removeAll()
                self.surahList.append(contentsOf: response.arabic_surah ?? [])
                if !self.surahList.isEmpty{
                    self.surahTableView.reloadData()
                   
                }
                
                self.spiner.isHidden = true
                self.spiner.stopAnimating()
                
            }
        
        }, onError: { message in
            print(message as Any)
        })


    }
    
    
    
    
    func fetchMusicUrl(with idx:Int) {
        self.objSingleton.surah_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                self.surahList.removeAll()
                self.surahList.append(contentsOf: response.arabic_surah ?? [])
                if !self.surahList.isEmpty{
                    if self.musicIdx<self.surahList.count{
                        let txt  = self.surahList[idx].name as? String ?? ""
                        self.musicLbl.text = txt
                        self.setupMusicUI(url: self.surahList[self.musicIdx].file as? String ?? "", str: txt)
                    }
                }
                
//                self.surahTableView.reloadData()
            }
        }, onError: { message in
            print(message as Any)
        })

    }
    
}
extension SurahVC{
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
extension SurahVC{
   /* func hijriApi(){
        let objSingleton = SingletonApi()
        objSingleton.hijriLabelAPI(onSuccess: { response in
            print(response)
            DispatchQueue.main.async {
              // self.floatLabelList = response["message"]["animatedtext"].arrayValue
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
                //print(self.lblHijri)
            }
        }, onError: { message in
            print(message as Any)
        })
    } */
    
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
    }
    
    func floatingLabel () {
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
                    
                    strFinalVal = strFinalVal + "  " + element["heading"].stringValue
                }
                var finalString = ""
                let remove_Word = ["</b>","</b>","<b>","</b>","<b>","</b>","<b>","</b>"]
                
                var firstString = strFinalVal.replacingOccurrences(of: "<b>Imam", with: " Imam", options: .regularExpression, range: nil)
                firstString = firstString.replacingOccurrences(of: "<b>Haji", with: " Haji", options: .regularExpression, range: nil)
               
                var stringArray  = firstString.components(separatedBy: " ")
                stringArray = stringArray.filter { !remove_Word.contains($0) }
                finalString = stringArray.joined(separator: " ")
                self.floatingLbl.text = finalString
            }
        }, onError: { message in
            print(message as Any)
        })
    }

    
    func startMarqueeAnimation() {
           // Set up animation
           UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear, .repeat], animations: {
               // Adjust the x-coordinate based on the label's width
               self.floatingLbl.frame.origin.x = -self.floatingLbl.frame.width
               //self.floatingLbl.speed = .duration(10)
           }, completion: nil)
        
       }
    
    
    func setupUI() {
        UIView.animate(withDuration: 10, delay: 0.01, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            var marqueeStyle = DefaultStyle()
           // marqueeStyle.backColor = .lightGray
            marqueeStyle.showFullText = true
            self.floatingLbl.style  = marqueeStyle
            self.floatingLbl.textColor = .white
            self.floatingLbl.font = .preferredFont(forTextStyle: .title1)
            self.floatingLbl.text =  DailyDuaVC.globalFloatinglable
//            self.floatingLbl.text = "Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label!!Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Floating Label Label Floating Label Floating Label !!"
        }, completion:  { _ in
            
        })
    }
    
}
extension SurahVC{
    
    /*  func setupMusicUI(url:String,str:String) {
     var fetchedUrl = url
     let url = URL(string: fetchedUrl)
     let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
     player = AVPlayer(playerItem: playerItem)
     
     player?.playImmediately(atRate: globalSpeed)
     
     self.isPlayingOutside = true
     self.isCellMusicPlaying = true
     surahTableView.reloadData()
     
     ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
     NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
     
     // Add playback slider
     playbackSlider.minimumValue = 0
     
     playbackSlider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
     
     duration = playerItem.asset.duration
     let seconds : Float64 = CMTimeGetSeconds(duration)
     lblcurrentText.text = self.stringFromTimeInterval(interval: seconds)
     
     let duration1 : CMTime = playerItem.currentTime()
     let seconds1 : Float64 = CMTimeGetSeconds(duration1)
     
     setupNowPlaying(strTitle: str, strDuration: Float(seconds))
     setupRemoteCommandCenter()
     
     playbackSlider.maximumValue = Float(seconds)
     playbackSlider.isContinuous = true
     playbackSlider.tintColor = UIColor.white
     
     player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
     if self.player!.currentItem?.status == .readyToPlay {
     let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
     self.playbackSlider.value = Float ( time );
     var reverseTime = CMTimeGetSeconds(self.duration) - time
     self.lblcurrentText.text = self.stringFromTimeInterval(interval: reverseTime)
     
     }
     
     let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
     if playbackLikelyToKeepUp == false{
     print("IsBuffering")
     self.ButtonPlay.isHidden = false
     //                self.loadingView.isHidden = true
     } else {
     //stop the activity indicator
     print("Buffering completed")
     self.ButtonPlay.isHidden = false
     //                self.loadingView.isHidden = true
     }
     
     }
     } */
    
    func setupMusicUI(url:String,str:String) {
       var fetchedUrl = url
        guard let url = URL(string: fetchedUrl) else { return }
       let playerItem:AVPlayerItem = AVPlayerItem(url: url)
       player = AVPlayer(playerItem: playerItem)
        audio_Name = str
       let val = UserDefaults.standard.value(forKey: "speedUpadte") as? Float ?? 0.0
       player?.playImmediately(atRate: globalSpeed)
       surahTableView.reloadData()
        self.spiner.isHidden = true
        self.spiner.stopAnimating()
       self.isPlayingOutside = true
       self.isCellMusicPlaying = true
       self.musicLbl.text = str
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
    
    
}


extension SurahVC{
    private func musicDelegate(){
//        tfLang.inputView = langPicker
//        langPicker.tag = 0
        pickerView.tag = 1
        langPicker.delegate = self
        langPicker.dataSource = self
     //   tfLang.text = strLang
        pickerView.delegate = self
        pickerView.dataSource = self
//        fetchMusicUrl()
        pickerView.isHidden = true
    }
}
extension SurahVC: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: - Picker Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView.tag == 0{
//            return arrLang[row]
//        }else {
            return audioSpeed[row]
       // }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView.tag == 0{
//            return arrLang.count
//        }else{
            return audioSpeed.count
      //  }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
                player?.rate = speed
                pickerView.isHidden = true

            default:
                break
            }
        }
    }
    
    
extension SurahVC {
    
    func playNext(){
        
        DispatchQueue.main.async {
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            self.musicIdx += 1
            self.isTapSound = true
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
                self.surahTableView.reloadData()
                self.fetchMusicUrl(with: self.musicIdx)
               
            }else{
                self.isTapSound = true
                self.musicIdx = 0
                self.isPlayingOutside = true
                self.surahTableView.reloadData()
                self.fetchMusicUrl(with: self.musicIdx)
                print("Less than Zero")
            }
            
        }
        
    }
    
    /*
    func setupNowPlaying(strTitle: String, strDuration: Float) {
        // Set metadata for lock screen display
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = strTitle
       // nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: albumArtImage) // Optional artwork
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = strDuration
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        player?.play()
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.playCommand.addTarget { [unowned self] event in
                self.player?.play()
                return .success
            }
            commandCenter.pauseCommand.addTarget { [unowned self] event in
                self.player?.pause()
                return .success
            }
            commandCenter.nextTrackCommand.addTarget { [unowned self] event in
               // self.playNextSong() // Implement your song switching logic here
                DispatchQueue.main.async {
                    self.isTapSound = true
                    self.isPlayingOutside = true
                    self.musicIdx += 1
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                return .success
            }
            commandCenter.previousTrackCommand.addTarget { [unowned self] event in
               // self.playPreviousSong() // Implement your song switching logic here
                DispatchQueue.main.async {
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
                return .success
            }
    }
    */
    
}

extension SurahVC {
    
    func updateNowPlayingInfo(strTitle: String) {
        var nowPlayingInfo = [String: Any]()

        // Set the title
        nowPlayingInfo[MPMediaItemPropertyTitle] = strTitle

        // Set the duration (total time)
        if let duration = player?.currentItem?.asset.duration {
            let durationInSeconds = CMTimeGetSeconds(duration)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        }

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
                surahTableView.reloadData()
                return .success
                return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] event in
                self.player?.rate = globalSpeed
                self.player?.pause()
                ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                self.isPlayingOutside = false
                flag = false
                surahTableView.reloadData()
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
    
}

extension SurahVC {
    
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
