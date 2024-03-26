//
//  DetailsFabVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 22/03/24.
//

import UIKit
import SwiftyJSON
import AVFoundation
import SystemConfiguration
import CoreTelephony
import MediaPlayer
import AVKit

class DetailsFabVC: UIViewController {

    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var speedBtn: UIButton!
    @IBOutlet weak var audioDurationLbl: UILabel!
    @IBOutlet weak var audioSlaider: UISlider!
    @IBOutlet weak var audioTrackLbl: UILabel!
    @IBOutlet weak var audioSpeedPicker: UIPickerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var lblVcTitle: UILabel!
    @IBOutlet weak var airPlayView: UIView!
    
    
    var storyboardTitle = ""
    var arrFavList  : [JSON] = []
    let audioSpeed = ["0.5x", "0.75x", "normal", "1.25x", "1.5x", "1.75x", "2x", "4x"]
    var speed:Float = 1
    var player: AVPlayer?
    var isTapSound = true
    var isPlayingOutside = false
    var isCellMusicPlaying = false
    var flag: Bool = true
    var duration: CMTime = CMTime(value: CMTimeValue(0), timescale: 0)
    var index = 0
    var audio_Name: String?
    var shared = SingletonRemotControl.shareAPIdata
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        airplaybtnSet()
        shared.favDetailsVC = self
        tblView.backgroundColor = .clear
        tblView.dataSource = self
        tblView.delegate = self
        musicViewBackground()
        audioSpeedPicker.isHidden = true
        audioSpeedPicker.dataSource = self
        audioSpeedPicker.delegate = self
        spiner.isHidden = false
        spiner.startAnimating()
        if storyboardTitle == "Listen your favorite Dua" {
            self.favDuaListDetailsApi()
            
        } else if storyboardTitle == "Listen your favorite Sahifa Sajjadia" {
            self.favSahifaListDetailsApi()
            
        } else if storyboardTitle == "Listen your favorite Ziyarat" {
            self.favZiyaratListDetailsApi()
            
        } else if storyboardTitle == "Listen your favorite Surah" {
            self.favSurahListDetailsApi()
            
        } else {
            
            self.favAllListDetailsApi()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        lblVcTitle.text = storyboardTitle
        globalControlerName = "DetailsFabVC"
        navigationController?.setNavigationBarHidden(true, animated: true)
        modeCheck()
        self.tblView.reloadData()
        shared.setupRemoteTransportControls()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        player?.pause()
//        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        player?.pause()
        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        player = nil
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnTapBack(_ sender: UIButton) {
        plaxBack()
    }
    
    @IBAction func btnTapMusicPlay(_ sender: UIButton) {
        print(audio_Url)
        if player?.rate == 0
        {
            self.isPlayingOutside = true
            print(speed)
            player?.rate = globalSpeed
            player?.play()
            //self.btnPlay.isHidden = true
            flag = true
            btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
            tblView.reloadData()
        } else {
            player?.rate = globalSpeed
            player?.pause()
            btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            self.isPlayingOutside = false
            flag = false
            tblView.reloadData()
        }
        
    }
    
    @IBAction func btnTapNext(_ sender: UIButton) {
        playNext()
    }
    
    private func musicViewBackground(){
        musicView.backgroundColor = .lightGray
        musicView.layer.cornerRadius = 10
        musicView.clipsToBounds = true
        musicView.layer.borderWidth = 1
        musicView.layer.borderColor = UIColor.black.cgColor
    }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    @IBAction func speedBtn(_ sender: UIButton) {
        audioSpeedPicker.isHidden = false
    }
    
    
    //MARK: Airplay button
    func airplaybtnSet(){
        let buttonView  = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let routerPickerView =  AVRoutePickerView(frame: buttonView.bounds)
        routerPickerView.tintColor = UIColor.white
        routerPickerView.activeTintColor = .white
        buttonView.addSubview(routerPickerView)
        self.airPlayView.addSubview(buttonView)
    }
    
    
    //MARK: Mark Api Call
    func favDuaListDetailsApi(){
        let objSingleton = SingletonApi()
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
            print(response)
            DispatchQueue.main.async { [self] in
                self.arrFavList = response.arrayValue
                let url = arrFavList[index]["file"].stringValue
                let str = arrFavList[index]["name"].stringValue
                self.playMusicfromUrl(url:url,str:str)
                print(self.arrFavList)
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    
    func favSahifaListDetailsApi(){
        let objSingleton = SingletonApi()
        
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favSahifaListDetailsAPI(userid: userId, onSuccess: { response in
            print(response)
            DispatchQueue.main.async { [self] in
                self.arrFavList = response.arrayValue
                self.arrFavList = response.arrayValue
                let url = arrFavList[index]["file"].stringValue
                let str = arrFavList[index]["name"].stringValue
                self.playMusicfromUrl(url:url,str:str)
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    
    
    func favZiyaratListDetailsApi(){
        let objSingleton = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favZiyaratListDetailsAPI(userid: userId, onSuccess: { response in
            print(response)
            DispatchQueue.main.async { [self] in
                self.arrFavList = response.arrayValue
                self.arrFavList = response.arrayValue
                let url = arrFavList[index]["file"].stringValue
                let str = arrFavList[index]["name"].stringValue
                self.playMusicfromUrl(url:url,str:str)
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    func favSurahListDetailsApi(){
        let objSingleton = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favSurahListDetailsAPI(userid: userId, onSuccess: { response in
            print(response)
            DispatchQueue.main.async { [self] in
                self.arrFavList = response.arrayValue
                self.arrFavList = response.arrayValue
                let url = arrFavList[index]["file"].stringValue
                let str = arrFavList[index]["name"].stringValue
                self.playMusicfromUrl(url:url,str:str)
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    
    func favAllListDetailsApi(){
        let objSingleton = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favAllListDetailsAPI(userid: userId, onSuccess: { response in
            print(response)
            DispatchQueue.main.async { [self] in
                self.arrFavList = response.arrayValue
                self.arrFavList = response.arrayValue
                let url = arrFavList[index]["file"].stringValue
                let str = arrFavList[index]["name"].stringValue
                self.playMusicfromUrl(url:url,str:str)
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    

    
    func playMusicfromUrl(url:String,str:String){
        var fetchedUrl = url
        guard let url = URL(string: fetchedUrl) else {return}
        let playerItem:AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.playImmediately(atRate: globalSpeed)
        audio_Name = str
        globalName = str
        tblView.reloadData()
        self.spiner.isHidden = true
        self.spiner.stopAnimating()
        self.isPlayingOutside = true
        self.isCellMusicPlaying = true
        self.audioTrackLbl.text = str
        btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        
        //MARK: Add playback slider
        audioSlaider.minimumValue = globalSpeed
        audioSlaider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
        duration = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
         
        let duration1 : CMTime = playerItem.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        audioDurationLbl.text = self.stringFromTimeInterval(interval: seconds1)
        audioSlaider.maximumValue = Float(seconds)
        audioSlaider.isContinuous = true
        audioSlaider.tintColor = UIColor.white
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
            if self.player?.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.audioSlaider.value = Float ( time );
                
                
                shared.updateNowPlayingInfo(strTitle: str, duration: duration, playbackTime: time)
                
                
                var reverseTime = CMTimeGetSeconds(duration) - time
                self.audioDurationLbl.text = self.stringFromTimeInterval(interval: reverseTime)
            }
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
                self.btnPlay.isHidden = false
            } else {
                //stop the activity indicator
                print("Buffering completed")
                self.btnPlay.isHidden = false
            }
            
        }
        
    }
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
            // Automatically play the next track when the current track finishes
            playNext()
        }
    
    func playNext() {
            DispatchQueue.main.async { [self] in
                
                self.index += 1
                if index >= arrFavList.count {
                    self.spiner.isHidden = false
                    self.spiner.startAnimating()
                    self.isTapSound = true
                    self.isPlayingOutside = true
                    self.index = 0
                    let url = arrFavList[index]["file"].stringValue
                    let str = arrFavList[index]["name"].stringValue
                    self.playMusicfromUrl(url:url,str:str)
                    //self.fetchMusicUrl(with: 0)
                } else {
                    self.spiner.isHidden = false
                    self.spiner.startAnimating()
                    self.isTapSound = true
                    self.isPlayingOutside = true
                    let url = arrFavList[index]["file"].stringValue
                    let str = arrFavList[index]["name"].stringValue
                    self.playMusicfromUrl(url:url,str:str)
                   // self.fetchMusicUrl(with: index)
                    print(self.index)
                }
            
            }
      }
    
    func plaxBack(){
        
        DispatchQueue.main.async { [self] in
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            self.index -= 1
            if self.index >= 0{
                self.isTapSound = true
                self.isPlayingOutside = true
                let url = arrFavList[index]["file"].stringValue
                let str = arrFavList[index]["name"].stringValue
                self.playMusicfromUrl(url:url,str:str)
                //self.fetchMusicUrl(with: index)
               
            }else{
                self.isPlayingOutside = true
                self.isTapSound = true
                self.index = 0
                let url = arrFavList[index]["file"].stringValue
                let str = arrFavList[index]["name"].stringValue
                self.playMusicfromUrl(url:url,str:str)
                print("Less than Zero")
            }
            
        }
        
    }
    
    
    
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
    

    @objc func finishedPlaying( _ myNotification:NSNotification) {
        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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



extension DetailsFabVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsFavTVCell", for: indexPath) as!
        DetailsFavTVCell
        cell.favourtiteImage.tag = indexPath.row
        cell.favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeFav)))
        cell.duration_Lbl.text = arrFavList[indexPath.row]["duration"].stringValue
        cell.favouriteTitleLbl.text = arrFavList[indexPath.row]["name"].stringValue
        cell.playBtn.tag = indexPath.row
        if index == indexPath.row{
            if isPlayingOutside == true{
                cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                
            }else{
                cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            }
        }
        else{
            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        }
        cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
        cell.sepratorView.backgroundColor = .white
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //120
    }
    
    @objc func getIndex(){
        
    }
    
    @objc func makeFav(_ sender:UITapGestureRecognizer){
        
        let objSingletion = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        let tag = sender.view?.tag as? Int ?? 0
        let arr = arrFavList[tag]
        let audioID = arr["id"].intValue
       
        if storyboardTitle == "Listen your favorite Dua" {
            objSingletion.addFavouriteAndUnfavouriteDua(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: AppName, message: "Unfavourite Successfull", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    self.favDuaListDetailsApi()
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }, onError: { massage in
 
             print(massage as Any)
             DispatchQueue.main.async {
                 print("It's error")
             }
 
         })
            
        } else if storyboardTitle == "Listen your favorite Sahifa Sajjadia" {
            objSingletion.addFavouriteAndUnfavouriteSahifaSajjadia(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: AppName, message: "Unfavourite Successfull", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    self.favSahifaListDetailsApi()
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }, onError: { massage in
 
             print(massage as Any)
             DispatchQueue.main.async {
                 print("It's error")
             }
 
         })
            
        } else if storyboardTitle == "Listen your favorite Ziyarat" {
            objSingletion.addFavouriteAndUnfavouriteZiyarat(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: AppName, message: "Unfavourite Successfull", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    self.favZiyaratListDetailsApi()
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }, onError: { massage in
 
             print(massage as Any)
             DispatchQueue.main.async {
                 print("It's error")
             }
 
         })
        
        } else if storyboardTitle == "Listen your favorite Surah" {
            objSingletion.addFavouriteAndUnfavouriteSurah(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: AppName, message: "Unfavourite Successfull", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    self.favSurahListDetailsApi()
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }, onError: { massage in
 
             print(massage as Any)
             DispatchQueue.main.async {
                 print("It's error")
             }
 
         })
            
        }else {
            self.favAllListDetailsApi()
        }
        
    }
    
    //DetailsFavTVCell
    
    
    @objc func playCellMusic(_ sender:UIButton){
        var isPlay = true
        if isPlayingOutside == true{
            let tag = sender.tag as? Int ?? 0
            index = tag
            let idx = IndexPath(row: tag, section: 0)
            let cell = tblView.cellForRow(at: idx) as! DetailsFavTVCell
            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            isPlayingOutside = false
            btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            player?.pause()
        }
        else{
            let tag = sender.tag as? Int ?? 0
            index = tag
            let idx = IndexPath(row: tag, section: 0)
            let cell = tblView.cellForRow(at: idx) as! DetailsFavTVCell
            spiner.isHidden = false
            spiner.startAnimating()
            let url = arrFavList[index]["file"].stringValue
            let str = arrFavList[index]["name"].stringValue
            self.playMusicfromUrl(url:url,str:str)
           // fetchMusicUrlforCell(with: index , and: cell)
            isPlayingOutside = true
        }
    }
    
}
        
        
extension DetailsFabVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return audioSpeed.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return audioSpeed[row]
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
