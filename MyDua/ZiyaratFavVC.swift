//
//  ZiyaratFavVC.swift
//  MyDua
//
//  Created by iB Arts Pvt. Ltd. on 23/01/24.
//



import UIKit
import SwiftyJSON
import AVFoundation
import MediaPlayer

/*
class ZiyaratFavVC: UIViewController {
    var strStatus = ""
    var arrFavList  : [JSON] = []
    var fav: String!
    var indxid: Int!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var speedBtn: UIButton!
    @IBOutlet weak var audioDurationLbl: UILabel!
    @IBOutlet weak var audioSlaider: UISlider!
    @IBOutlet weak var audioTrackLbl: UILabel!
    @IBOutlet weak var audioSpeedPicker: UIPickerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    weak var vc1:FavouriteDuaVC?
    let audioSpeed = ["0.5x", "0.75x", "normal", "1.25x", "1.5x", "1.75x", "2x", "4x"]
    var speed:Float = 1
    var player: AVPlayer?
//    var players: [AVAudioPlayer] = []
    var playerItem: AVPlayerItem?
    var audioUrl = ""
    var isTapSound = true
  var musicIdx = 0
    var isPlayingOutside = true
    var isCellMusicPlaying = false
    var flag: Bool = true
    let volumeView = MPVolumeView()
    var duration: CMTime = CMTime(value: CMTimeValue(0), timescale: 0)
    var index = 0
    var currentPlayerIndex = 0
    var shareds = MusicPlay.shared
    var strPlayName = ""
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        arrFavList.removeAll()
        UIApplication.shared.isIdleTimerDisabled = true
        tblView.dataSource = self
        tblView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(observeValue(_:)), name: NSNotification.Name("sendValue"), object: nil)
        musicViewBackground()
        vc1?.player?.pause()
        vc1?.player = nil
        shareds.vc3 = self
        /*
        spiner.isHidden = false
        spiner.startAnimating()
        if strStatus == "Listen your favorite Dua" {
            
            self.favDuaListDetailsApi()
            
        } else if strStatus == "Listen your favorite Sahifa Sajjadia" {
            
            self.favSahifaListDetailsApi()
            
            
        } else if strStatus == "Listen your favorite Ziyarat" {
            self.favZiyaratListDetailsApi()
           
            
        } else if strStatus == "Listen your favorite Surah" {
            self.favSurahListDetailsApi()
           
            
        } else {
            self.favAllListDetailsApi()
            player?.pause()
        }
        */
        
       // btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        
        audioSpeedPicker.isHidden = true
        audioSpeedPicker.dataSource = self
        audioSpeedPicker.delegate = self
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        player?.pause()
        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        player = nil
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        vc1?.player?.pause()
        vc1?.player = nil
        
        modeCheck()
        setupRemoteCommandCenter()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
        player = nil
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
  /*  @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }*/
    
    
    @IBAction func btnTapBack(_ sender: UIButton) {
        print("Back")
        DispatchQueue.main.async { [self] in
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            self.index -= 1
            if self.index >= 0{
                self.isTapSound = true
                self.isPlayingOutside = true
                shareds.fetchMusicUrl(tblView: tblView, strStat: self.strStatus, idx: index){
                    str in
                    self.spiner.isHidden = true
                         self.spiner.stopAnimating()
                         self.isPlayingOutside = true
                         self.isCellMusicPlaying = true
                         self.audioTrackLbl.text = str
                    self.strPlayName = str
                    self.tblView.reloadData()
                    self.btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                }
//                self.fetchMusicUrl(with: index)
               
            }else{
                self.spiner.isHidden = true
                self.isPlayingOutside = true
                self.isTapSound = true
                self.index = 0
                print("Less than Zero")
            }
            
        }
    }
    
    @IBAction func btnTapMusicPlay(_ sender: UIButton) {
        print(audio_Url)
        
        if shareds.player?.rate == 0
        {
            self.isPlayingOutside = false
            print(speed)
            shareds.player?.rate = globalSpeed
            shareds.player?.play()
            flag = true
            btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
            tblView.reloadData()
        } else {
            shareds.player?.rate = globalSpeed
            shareds.player?.pause()
            btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            self.isPlayingOutside = true
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
    
    
    //MARK: Mark Api Call
    func favDuaListDetailsApi(){
        let objSingleton = SingletonApi()

        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
            print(response)
           // self.arrFavList.append(contentsOf: response.arrayValue)
            DispatchQueue.main.async { [self] in
                print(self.arrFavList)
                self.arrFavList = response.arrayValue
                if response.count != 0 {
                    let url = arrFavList[0]["file"].stringValue as? String ?? ""
                    let str = arrFavList[0]["name"].stringValue as? String ?? ""
//                    self.setupMusicUI(url:url,str:str)
                } else {
                    let alert = UIAlertController(title: AppName, message: "No favourite data found", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(ok)
                    present(alert, animated: true)
                    self.spiner.stopAnimating()
                    self.spiner.isHidden = true
                }
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
            self.arrFavList = []
            self.arrFavList.append(contentsOf: response.arrayValue)
            DispatchQueue.main.async { [self] in
                print(self.arrFavList)
                if self.arrFavList.count != 0 {
                    self.arrFavList = response.arrayValue
                    let url = arrFavList[0]["file"].stringValue as? String ?? ""
                    let str = arrFavList[0]["name"].stringValue as? String ?? ""


//                    self.tblView.reloadData()
//                    spiner.isHidden = true
//                    spiner.stopAnimating()
                } else {
                    let alert = UIAlertController(title: AppName, message: "No favourite data found", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(ok)
                    present(alert, animated: true)
                    self.spiner.stopAnimating()
                    self.spiner.isHidden = true
                }
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    func favZiyaratListDetailsApi(){
        let objSingleton = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favZiyaratListDetailsAPI(userid: userId, onSuccess: { response in
           // print(response)
            self.arrFavList = []
            self.arrFavList.append(contentsOf: response.arrayValue)
            DispatchQueue.main.async { [self] in
                print(self.arrFavList)
                print(arrFavList.count)
                if self.arrFavList.count != 0 {
                    self.arrFavList = response.arrayValue
                    let url = arrFavList[0]["file"].stringValue as? String ?? ""
                    let str = arrFavList[0]["name"].stringValue as? String ?? ""
                    shareds.setupMusicUI(url: url, str: str, tblView: tblView, strStat: self.strStatus, idx: index) { bool in
                        self.spiner.isHidden = true
                             self.spiner.stopAnimating()
                             self.isPlayingOutside = true
                             self.isCellMusicPlaying = true
                             self.audioTrackLbl.text = str
                        btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                    }

                    
                    
                } else {
                    let alert = UIAlertController(title: AppName, message: "No favourite data found", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(ok)
                    present(alert, animated: true)
                    self.spiner.stopAnimating()
                    self.spiner.isHidden = true
                }
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
            self.arrFavList = []
            self.arrFavList.append(contentsOf: response.arrayValue)
            DispatchQueue.main.async { [self] in
                print(self.arrFavList)
                if self.arrFavList.count != 0 {
                    self.arrFavList = response.arrayValue
                    let url = arrFavList[0]["file"].stringValue as? String ?? ""
                    let str = arrFavList[0]["name"].stringValue as? String ?? ""
//                    self.setupMusicUI(url:url,str:str)
//                    self.tblView.reloadData()
//                    spiner.isHidden = true
//                    spiner.stopAnimating()
                } else {
                    let alert = UIAlertController(title: AppName, message: "No favourite data found", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(ok)
                    present(alert, animated: true)
                    self.spiner.stopAnimating()
                    self.spiner.isHidden = true
                }
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
            self.arrFavList = []
            self.arrFavList.append(contentsOf: response.arrayValue)
            DispatchQueue.main.async { [self] in
                print(self.arrFavList)
                if self.arrFavList.count != 0 {
                    self.arrFavList = response.arrayValue
                    let url = arrFavList[index]["file"].stringValue as? String ?? ""
                    let str = arrFavList[index]["name"].stringValue as? String ?? ""
//                    self.setupMusicUI(url:url,str:str)
//                    self.tblView.reloadData()
//                    spiner.isHidden = true
//                    spiner.stopAnimating()
                } else {
                    let alert = UIAlertController(title: AppName, message: "No favourite data found", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(ok)
                    present(alert, animated: true)
                    self.spiner.stopAnimating()
                    self.spiner.isHidden = true
                }
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    
    
    
    //MARK: Fatch index wise
    func fetchMusicUrl(with idx:Int){
        if strStatus == "Listen your favorite Dua" {
            let objSingleton = SingletonApi()
            let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
            objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
                DispatchQueue.main.async { [self] in
                    print(self.arrFavList)
                    self.arrFavList = response.arrayValue
                    let url = arrFavList[idx]["file"].stringValue as? String ?? ""
                    let str = arrFavList[idx]["name"].stringValue as? String ?? ""
                    self.setupMusicUI(url:url,str:str)
                }
            }, onError: { message in
                print(message as Any)
            })
           
            

            
        } else if strStatus == "Listen your favorite Sahifa Sajjadia" {
            self.favSahifaListDetailsApi()
            
        } else if strStatus == "Listen your favorite Ziyarat" {
            self.favZiyaratListDetailsApi()
            
        } else if strStatus == "Listen your favorite Surah" {
            self.favSurahListDetailsApi()
            
        } else if strStatus == "Listen your All favorite" {
            
            self.favAllListDetailsApi()
            
        } else {
            
            self.favDuaListDetailsApi()
            
        }
        
    }
    
    
    
    //MARK: Fatch cell wise
    func fetchMusicUrlforCell(with idx:Int,and cell:FavouriteTableViewCell){
        if strStatus == "Listen your favorite Dua" {
            self.favDuaListDetailsApi()
            
        } else if strStatus == "Listen your favorite Sahifa Sajjadia" {
            self.favSahifaListDetailsApi()
            
        } else if strStatus == "Listen your favorite Ziyarat" {
            self.favZiyaratListDetailsApi()
            
        } else if strStatus == "Listen your favorite Surah" {
            self.favSurahListDetailsApi()
            
        } else if strStatus == "Listen your All favorite" {
            
            self.favAllListDetailsApi()
       
        } else {
            
            self.favDuaListDetailsApi()
            
        }
        
    }
    
    func setupMusicUI(url:String,str:String) {
     //  player = nil
       var fetchedUrl = url
       guard let url = URL(string: fetchedUrl) else { return }
       let playerItem:AVPlayerItem = AVPlayerItem(url: url)
       player = AVPlayer(playerItem: playerItem)
       player?.playImmediately(atRate: globalSpeed)
       tblView.reloadData()
       self.spiner.isHidden = true
       self.spiner.stopAnimating()
       self.isPlayingOutside = true
       self.isCellMusicPlaying = true
       self.audioTrackLbl.text = str
       btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
       NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
       NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
       //MARK: Add playback slider
       audioSlaider.minimumValue = globalSpeed
       audioSlaider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
       duration = playerItem.asset.duration
       let seconds : Float64 = CMTimeGetSeconds(duration)
        
     //  setupNowPlaying(strTitle: str, strDuration: Float(seconds))
       
        
       let duration1 : CMTime = playerItem.currentTime()
       let seconds1 : Float64 = CMTimeGetSeconds(duration1)
       audioDurationLbl.text = self.stringFromTimeInterval(interval: seconds1)
       audioSlaider.maximumValue = Float(seconds)
       audioSlaider.isContinuous = true
       audioSlaider.tintColor = UIColor.white
       player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
           if self.player?.currentItem?.status == .readyToPlay {
               let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
               self.audioSlaider.value = Float ( time );
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
                self.spiner.isHidden = false
                self.spiner.startAnimating()
                self.isTapSound = true
                self.isPlayingOutside = true
                shareds.fetchMusicUrl(tblView: tblView, strStat: self.strStatus, idx: index){
                    str in
                    self.spiner.isHidden = true
                         self.spiner.stopAnimating()
                         self.isPlayingOutside = true
                         self.isCellMusicPlaying = true
                         self.audioTrackLbl.text = str
                    self.tblView.reloadData()
                    self.strPlayName = str
                    btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                }
                //                self.fetchMusicUrl(with: index)
                print(self.index)
            
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
    
//    func playMusic(at index: Int) {
//        if let player = players[safe: index] {
//            player.play()
//        } else {
//            print("Invalid track index!")
//        }
//    }
    
}

extension ZiyaratFavVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as!
        FavouriteTableViewCell
        cell.favourtiteImage.tag = indexPath.row
        cell.favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeFav)))
        cell.duration_Lbl.text = arrFavList[indexPath.row]["duration"].stringValue
        cell.favouriteTitleLbl.text = arrFavList[indexPath.row]["name"].stringValue
        cell.playBtn.tag = indexPath.row
        
        
        let arr = arrFavList[indexPath.row]
        
        if strPlayName == arr["name"].stringValue as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
            if isPlayingOutside == true{
                cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                
            }
            else{
                cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            }
            
        }
        else{
            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        }
       
        
      /*
        if index == indexPath.row{
            if isPlayingOutside == false {
                cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                
            }else{
                cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            }
        }
        else{
            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        }
       
        */
        cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
      //  return UITableView.automaticDimension
    }
    
    @objc func getIndex(){
        
    }
    
    @objc func observeValue(_ notification:Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("sendValue"), object: nil)
        let valu = notification.userInfo!["strStatus"] as? String ?? ""
        self.strStatus = valu
        print(self.strStatus)
        if strStatus == "Listen your favorite Dua" {
            spiner.isHidden = false
            spiner.startAnimating()
           
            self.favDuaListDetailsApi()
            
            
            
        } else if strStatus == "Listen your favorite Sahifa Sajjadia" {
            spiner.isHidden = false
            spiner.startAnimating()
            self.favSahifaListDetailsApi()
            
            
        } else if strStatus == "Listen your favorite Ziyarat" {
            spiner.isHidden = false
            spiner.startAnimating()
            self.favZiyaratListDetailsApi()
           
            
        } else if strStatus == "Listen your favorite Surah" {
            spiner.isHidden = false
            spiner.startAnimating()
            self.favSurahListDetailsApi()
           
            
        } else if strStatus == "Listen your All favorite"  {
            spiner.isHidden = false
            spiner.startAnimating()
            self.favAllListDetailsApi()
       
        } else {
            
            spiner.isHidden = false
            spiner.startAnimating()
            self.favDuaListDetailsApi()
            
        }
        
    }
    
    
    
    
    @objc func makeFav(_ sender:UITapGestureRecognizer){
        
        let objSingletion = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        let tag = sender.view?.tag as? Int ?? 0
        let arr = arrFavList[tag]
        let audioID = arr["id"].intValue
       
        if strStatus == "Listen your favorite Dua" {
            objSingletion.addFavouriteAndUnfavouriteDua(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                    // print(response)
                    
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
            
        } else if strStatus == "Listen your favorite Sahifa Sajjadia" {
            objSingletion.addFavouriteAndUnfavouriteSahifaSajjadia(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                   // print(response)
                    
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
            
        } else if strStatus == "Listen your favorite Ziyarat" {
            objSingletion.addFavouriteAndUnfavouriteZiyarat(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                   // print(response)
                    
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
        
        } else if strStatus == "Listen your favorite Surah" {
            objSingletion.addFavouriteAndUnfavouriteSurah(userId: userId, audioId: audioID, onSuccess: { response in
                DispatchQueue.main.async {
                   // print(response)
                    
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
    
    
    
    @objc func playCellMusic(_ sender:UIButton){
        
        var isPlay = true
        if isPlayingOutside == true{
            let tag = sender.tag as? Int ?? 0
            musicIdx = tag
            let idx = IndexPath(row: tag, section: 0)
            let cell = tblView.cellForRow(at: idx) as! FavouriteTableViewCell
            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            isPlayingOutside = false
            btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            shareds.player?.pause()
        }
        else{
            let tag = sender.tag as? Int ?? 0
            musicIdx = tag
            let idx = IndexPath(row: tag, section: 0)
            let cell = tblView.cellForRow(at: idx) as! FavouriteTableViewCell
//            spiner.isHidden = false
//            spiner.startAnimating()
            print(musicIdx)
            shareds.fetchMusicForCell(with: musicIdx, and: cell, strPlayName: strPlayName, tblView: tblView) { str in
                
                self.isPlayingOutside = true
            }
//            fetchMusicUrl(with: musicIdx)
           // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            
           // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
            
        }
        
    }
    
}
        
        
extension ZiyaratFavVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
*/
