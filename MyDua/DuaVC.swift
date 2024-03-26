//
//  DuaVC.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import SwiftyJSON
import AVFoundation
import MarqueeLabel
import CoreTelephony
import AVKit
import MediaPlayer


class DuaVC: UIViewController {
    
    @IBOutlet weak var duaTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var floatingLbl: MarqueeLabel!
    @IBOutlet weak var lblHijri: UILabel!
    @IBOutlet weak var ButtonPlay: UIButton!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var audioLbl: UILabel!
    @IBOutlet weak var lblcurrentText: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var tfLang: UITextField!
    @IBOutlet weak var customAirPlayView: UIView!
    @IBOutlet weak var btnQR: UIButton!
    @IBOutlet weak var floatingView: UIView!
    
    let langPicker = UIPickerView()
    var arrLang = ["عربي","English","हिंदी","ગુજરાતી"]
    var isPlayingOutside = false
    var isCellMusicPlaying = false
    var defultDuaList : [JSON] = []
    var floatLabelList : [JSON] = []
    var player: AVPlayer?
    fileprivate let seekDuration: Float64 = 10
    let audioSpeed = ["0.5x", "0.75x", "normal", "1.25x", "1.5x", "1.75x", "2x", "4x"]
    var speed:Float = 0.0
    var isTapSound = true
    var audioUrl = ""
    private var musicIdx = 0
    var updateStrLang: String!
    var strLang = "عربي"
    var isTap = false
    let duaListCellHeight = 90.0
    var duaList = [English_dua]()
    var Hindi_duaList = [Hindi_dua]()
    var Arabic_duaList = [Arabic_dua]()
    var Gujrati_duaList = [Gujrati_dua]()
    var searchArrEng = [English_dua]()
    var searchArrHind = [Hindi_dua]()
    var searchArrAra = [Arabic_dua]()
    var searchArrGuj = [Gujrati_dua]()
    let objSingleton = SingletonApi()
    var searching: Bool?
    var flag: Bool = true
    var isPlayingSearchCell = false
    var duration: CMTime = CMTime(value: CMTimeValue(0), timescale: 0)
    private var trackSpeed:Float = 1.0
    var defultStr: String = ""
    var searchStr = ""
    private var strPlayName = ""
    var a = 0
    var isCameFomSearch = false
    var isChangeIdx = false
    var isCameFomSearchPlaying = true
    var prevIdx = 0
    var shared = SingletonRemotControl.shareAPIdata
    let commandCenter = MPRemoteCommandCenter.shared()
    var updateDay: Int?
    var audio_Name: String?
    
    
  
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
       // shared.updateNowPlayingInfo(strTitle: "", duration: CMTime(value: CMTimeValue(0), timescale: 0), playbackTime: 0)
        hijriApiChangeDate()
        musicIdx = 0
        globalControlerName = "DuaVC"
        fetchFavDuaList()
        duaTableView.reloadData()
        startTimer()
        let globalStrLang = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if globalStrLang == nil {
            strLang = "عربي"
        } else {
            strLang = globalStrLang!
            tfLang.text = strLang
        }
        fetchDuaList()
        modeCheck()
        if a == 1{
            print("go")
        }else{
            
        }
        shared.setupRemoteTransportControls()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shared.duaVC = self
        UIApplication.shared.isIdleTimerDisabled = true
        duaTableView.dataSource = self
        duaTableView.delegate = self
        searchBar.delegate = self
        let globalStrLang = UserDefaults.standard.string(forKey: "GlobalStrLang")
        if globalStrLang == nil {
            strLang = "عربي"
        } else {
            strLang = globalStrLang!
            tfLang.text = strLang
        }
        tfLang.text = strLang
        spiner.isHidden = false
        spiner.startAnimating()
        startTimer()
        musicViewBackground()
        setupUI()
        hijriApiChangeDate()
        musicDelegate()
        hide_Keyboard()
        airplaybtnSet()
        customizeQRbtn()
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
        UIApplication.shared.isIdleTimerDisabled = false
//        player?.pause()
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
    
    //MARK: Dark mode and Light mode check
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
            lblHijri.backgroundColor = .black
            searchBar.barTintColor = .black
            duaTableView.reloadData()
        } else {
            overrideUserInterfaceStyle = .light
            lblHijri.backgroundColor = .white
            searchBar.barTintColor = .systemBackground
            duaTableView.reloadData()
        }
    }

    //MARK: Hide Keyboard
    func hide_Keyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismisKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: Music View Background setup
    func musicViewBackground(){
        musicView.backgroundColor = .lightGray
        musicView.layer.cornerRadius = 10
        musicView.clipsToBounds = true
        musicView.layer.borderWidth = 1
        musicView.layer.borderColor = UIColor.black.cgColor
    }
    
    
    
    @IBAction func btnTapQr(_ sender: UIButton) {
        view.addSubview(qrView)
        qrView.addSubview(btnCancel)
        qrView.addSubview(qrImg)
        addConstant()
        qrView.isHidden = false
        btnCancel.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    
    var qrView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var qrImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        let img = UIImage(named: "MyDuaQR")
        imgView.image = img
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    
    @objc var btnCancel: UIButton = {
        let btn = UIButton()
        //btn.backgroundColor = .yellow
        btn.setImage(UIImage(named: "X1"), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        qrView.isHidden = true
    }
    
    func addConstant(){
        var constant = [NSLayoutConstraint]()
        constant.append(qrView.topAnchor.constraint(equalTo: floatingView.topAnchor, constant: 0 ))
        constant.append(qrView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0))
        constant.append(qrView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
        constant.append(qrView.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 0))
        
        constant.append(btnCancel.topAnchor.constraint(equalTo: qrView.topAnchor, constant: 8))
        constant.append(btnCancel.trailingAnchor.constraint(equalTo: qrView.trailingAnchor, constant: -8))
        constant.append(btnCancel.heightAnchor.constraint(equalToConstant: 40))
        constant.append(btnCancel.widthAnchor.constraint(equalToConstant: 40))
        
        constant.append(qrImg.topAnchor.constraint(equalTo: qrView.topAnchor, constant: 20))
        constant.append(qrImg.leadingAnchor.constraint(equalTo: qrView.leadingAnchor, constant: 10))
        constant.append(qrImg.trailingAnchor.constraint(equalTo: qrView.trailingAnchor, constant: -10))
        constant.append(qrImg.bottomAnchor.constraint(equalTo: qrView.bottomAnchor, constant: -20))
        
        NSLayoutConstraint.activate(constant)
    }
    
    
    func customizeQRbtn(){
        btnQR.layer.cornerRadius = 4
        btnQR.clipsToBounds = true
    }
    
    
    @IBAction func ButtonPlay(_ sender: Any) {
        if player?.rate == 0
        {
            player?.rate = globalSpeed
            self.isPlayingOutside = true
            flag = true
            ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
            UserDefaults.standard.setValue(true, forKey: "isPlaying")
            duaTableView.reloadData()
        } else {
            
            player?.pause()
            UserDefaults.standard.setValue(false, forKey: "isPlaying")
            self.isPlayingOutside = false
            flag = false
            ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            duaTableView.reloadData()
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

//MARK: - TableView & SearchBar Methods
extension DuaVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searching ?? false) {
            if strLang == "English"{
                return searchArrEng.count
            }
            else if self.strLang == "हिंदी" {
                return searchArrHind.count
            }
            else if self.strLang == "عربي"{
                return searchArrAra.count
            }
            else{
                return searchArrGuj.count
            }
        }
        else {
            if strLang == "English"{
                return duaList.count
            }
            else if self.strLang == "हिंदी" {
                return Hindi_duaList.count
            }
            else if self.strLang == "عربي"{
                return Arabic_duaList.count
            }
            else{
                return Gujrati_duaList.count
            }
            
            
            
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = duaTableView.dequeueReusableCell(withIdentifier: "DuaTableViewCell", for: indexPath) as? DuaTableViewCell {
            
            if traitCollection.userInterfaceStyle == .dark{
                cell.sepratorView.layer.borderColor = UIColor.white.cgColor
            }else{
                cell.sepratorView.layer.borderColor = UIColor.black.cgColor
            }
            if (!(searching ?? false)) {
                if strLang == "English"{
                    
                    let arr = duaList[indexPath.row]
                    if strPlayName == arr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                
                    if arr.fav == "No"{
                        cell.favourtiteImage.image = UIImage(named: "unFavourite")
                    }
                    else{
                        cell.favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green)
                       
                        //MARK: Favourit
                    }
                    
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                    cell.favourtiteImage.tag = indexPath.row
                    cell.favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeFav)))
                    cell.duaTitleLbl.text = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                    cell.duration_Lbl.text = arr.duration ?? ""

                }
                else if strLang == "हिंदी"{
                    
                    /*
                    if musicIdx == indexPath.row{
                        if isPlayingOutside == true{
                            cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        }else{
                            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                        }
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    */
                    
                    let arr = Hindi_duaList[indexPath.row]
                    
                    if strPlayName == arr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    
                    
                    
                    if arr.fav == "No"{
                        cell.favourtiteImage.image = UIImage(named: "unFavourite")
                    }
                    else{
                        cell.favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green)
                    }
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                    cell.favourtiteImage.tag = indexPath.row
                    cell.favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeFav)))
                    cell.duaTitleLbl.text = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                    cell.duration_Lbl.text = arr.duration ?? ""

                }
                else if self.strLang == "عربي"{
                    /*
                    if musicIdx == indexPath.row{
                        if isPlayingOutside == true{
                            cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        }
                        else{
                            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                        }
                    }
                    
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    */
                    let arr = Arabic_duaList[indexPath.row]
                    
                    if strPlayName == arr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    
                    
                    if arr.fav == "No"{
                        cell.favourtiteImage.image = UIImage(named: "unFavourite")
                    }
                    else{
                        cell.favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green)
                    }
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                    cell.favourtiteImage.tag = indexPath.row
                    cell.favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeFav)))
                    cell.duaTitleLbl.text = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                    cell.duration_Lbl.text = arr.duration ?? ""

                }
                else{
                    /*
                    if musicIdx == indexPath.row{
                        if isPlayingOutside == true{
                            cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        }
                        else{
                            cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                        }
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    */
                    
                    let arr = Gujrati_duaList[indexPath.row]
                    
                    if strPlayName == arr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    
                    
                    if arr.fav == "No"{
                        cell.favourtiteImage.image = UIImage(named: "unFavourite")
                        
                    }
                    else{
                        cell.favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green, renderingMode: .alwaysOriginal)
                    }
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                    cell.favourtiteImage.tag = indexPath.row
                    cell.favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeFav)))
                    cell.duaTitleLbl.text = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                    cell.duration_Lbl.text = arr.duration ?? ""

                }

            }
            
            else {
                if strLang == "English"{

                    let searchArr = searchArrEng[indexPath.row]
                    if strPlayName == searchArr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    
                    
//                    if defultStr == searchArr.name ?? ""{
//                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
//                    }else{
//                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
//                    }
                    
                    
                    cell.duaTitleLbl.text = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                    cell.duration_Lbl.text = searchArr.duration ?? ""
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                }
                else if strLang == "हिंदी"{
                    let searchArr = searchArrHind[indexPath.row]
                    
                    if strPlayName == searchArr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    
                    
                    cell.duaTitleLbl.text = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                    cell.duration_Lbl.text = searchArr.duration ?? ""
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                }
                else if self.strLang == "عربي"{
                    let searchArr = searchArrAra[indexPath.row]
                    
                    
                    
                    
                    if strPlayName == searchArr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    
                    cell.duaTitleLbl.text = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                    cell.duration_Lbl.text = searchArr.duration ?? ""
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                }
                else{
                    let searchArr = searchArrGuj[indexPath.row]
                    
                    
                    if strPlayName == searchArr.name as? String ?? "" && UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false {
                        cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                        
                    }
                    else{
                        cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    }
                    
                    
                    cell.duaTitleLbl.text = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                    cell.duration_Lbl.text = searchArr.duration ?? ""
                    cell.playBtn.tag = indexPath.row
                    cell.playBtn.addTarget(self, action: #selector(playCellMusic), for: .touchUpInside)
                }

            }
            //cell.selectionStyle = .none
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = storyboard?.instantiateViewController(withIdentifier: "AudioDetailVC") as? AudioDetailVC {
            if (!(searching ?? false)) {
                if strLang == "English"{
                    let arr = duaList[indexPath.row]
                    
                    cell.audioLbl = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                }
                else if strLang == "हिंदी"{
                    let arr = Hindi_duaList[indexPath.row]
                    cell.audioLbl = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                }
                else if self.strLang == "عربي"{
                    let arr = Arabic_duaList[indexPath.row]
                    cell.audioLbl = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                }
                else{
                    let arr = Gujrati_duaList[indexPath.row]
                    cell.audioLbl = arr.name ?? ""
                    cell.audioUrl = arr.file ?? ""
                }

            } else {
                if strLang == "English"{
                    let searchArr = searchArrEng[indexPath.row]
                    cell.audioLbl = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                }
                else if strLang == "हिंदी"{
                    let searchArr = searchArrHind[indexPath.row]
                    cell.audioLbl = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                }
                else if self.strLang == "عربي"{
                    let searchArr = searchArrAra[indexPath.row]
                    cell.audioLbl = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                }
                else{
                    let searchArr = searchArrGuj[indexPath.row]
                    cell.audioLbl = searchArr.name ?? ""
                    cell.audioUrl = searchArr.file ?? ""
                }

            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty) {
            if strLang == "English"{
                searching = false
                searchArrEng = duaList
                print(searchStr)
                player?.play()
               
            }else if strLang == "हिंदी"{
                searchArrHind = Hindi_duaList
                player?.play()
                
            }
            else if self.strLang == "عربي"{
                searchArrAra = Arabic_duaList
                player?.play()
               
            }else{
                searchArrGuj = Gujrati_duaList
                player?.play()
            
            }
        }
        else {
            if strLang == "English" {
                searchArrEng.removeAll()
            
                searchArrEng = duaList.filter{$0.caption!.contains(searchText.capitalized)}
//                print(musicIdx)
                searchStr  =  searchArrEng[musicIdx].name as? String ?? ""
                print(searchStr)
                isPlayingOutside = false
                if isCellMusicPlaying == true {
                    player?.pause()
                }
            }
            else if strLang == "हिंदी"{
                let str =
                searchArrHind = Hindi_duaList.filter{$0.caption!.contains(searchText.capitalized)}
                //searchStr = searchArrHind[musicIdx].name as? String ?? ""
                if isCellMusicPlaying == true {
                    player?.pause()
                    
                }
            }
            else if self.strLang == "عربي"{
                searchArrAra = Arabic_duaList.filter{$0.caption!.contains(searchText.capitalized)}
                if isCellMusicPlaying == true {
                    player?.pause()
                    
                }
            }
            else{
                searchArrGuj = Gujrati_duaList.filter{$0.caption!.contains(searchText.capitalized)}
                if isCellMusicPlaying == true {
                    player?.pause()
                   
                }
            }
            
        }
        searching = true
        duaTableView.reloadData()
        
    }
    @objc func makeFav(_ sender:UITapGestureRecognizer){
        spiner.isHidden = false
        spiner.startAnimating()
        let objSingleton = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        if userId != ""{
            if strLang == "English"{
                let tag = sender.view?.tag as? Int ?? 0
                let arr = duaList[tag]
                print(arr.name)
                
                objSingleton.makeFavourite(userId: userId, audioId: duaList[tag].id as? Int ?? 0,typeOfAudio: "duafavaudio"){
                    str in
                    if str == "success"{
                        self.fetchFavDuaList()
                    }else{
                        print("error")
                    }
                }
                
            }
            else if self.strLang == "हिंदी" {
                let tag = sender.view?.tag as? Int ?? 0
                objSingleton.makeFavourite(userId: userId, audioId: Hindi_duaList[tag].id as? Int ?? 0,typeOfAudio: "duafavaudio"){
                    str in
                    if str == "success"{
                        self.fetchFavDuaList()
                    }else{
                        print("error")
                    }
                }
                
            }
            else if self.strLang == "عربي"{
                let tag = sender.view?.tag as? Int ?? 0
                objSingleton.makeFavourite(userId: userId, audioId: Arabic_duaList[tag].id as? Int ?? 0,typeOfAudio: "duafavaudio"){
                    str in
                    if str == "success"{
                        self.fetchFavDuaList()
                    }else{
                        print("error")
                    }
                }
                
            }else{
                let tag = sender.view?.tag as? Int ?? 0
                objSingleton.makeFavourite(userId: userId, audioId:Gujrati_duaList[tag].id as? Int ?? 0,typeOfAudio: "duafavaudio"){
                    str in
                    if str == "success"{
                        self.fetchFavDuaList()
                    }else{
                        print("error")
                    }
                }
                
            }
            
        }
        else{
            self.spiner.isHidden = true
            self.spiner.stopAnimating()
            
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
        var isPlay = true
        if self.strLang == "English"{
            if (searching ?? false){
                if isPlayingOutside == true{
                    let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    print(searchArrEng[tag].name,searchArrEng[tag].file)
                    cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
//                    isPlayingOutside = false
//                    UserDefaults.standard.setValue(tag, forKey: "PrevSea")
                    let arr = searchArrEng[tag]
//                    strPlayName = arr.name as? String ?? ""
                  
                    ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                    
                    
//                    if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                    if strPlayName == arr.name as? String ?? ""{
                        
                        let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                        if (val == true)
                        {
                        strPlayName = arr.name as? String ?? ""
                        isPlayingOutside = false
                        player?.pause()
                        UserDefaults.standard.setValue(false, forKey: "Current")
                        UserDefaults.standard.removeObject(forKey: "Prev")
                        UserDefaults.standard.setValue(false, forKey: "isPlaying")
//                        self.duaTableView.reloadData()
                            
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                            
                            
                        }
                        
                        else{
                            strPlayName = arr.name as? String ?? ""
                            isPlayingOutside = true
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                        }

                       
                    }
                    
                    
                    else{
                        
                        let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                        if (val == true)
                        {
                            if strPlayName == arr.name as? String ?? ""{
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = false
                                player?.pause()
                                UserDefaults.standard.setValue(false, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                UserDefaults.standard.setValue(false, forKey: "isPlaying")
        //                        self.duaTableView.reloadData()
                                    
                                    searchStr = ""
                                    searchBar.searchTextField.text = ""
                                    isCameFomSearch = false
                                    isCameFomSearchPlaying = false
                                    searching = false
                                    self.duaTableView.reloadData()
                            }
                            
                            else{
                                strPlayName = arr.name as? String ?? ""
                               isPlayingOutside = true
                                fetchMusicUrl(with: musicIdx,and: cell)
//                                UserDefaults.standard.setValue(true, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                searchStr = ""
                                searchBar.searchTextField.text = ""
                                isCameFomSearch = false
                                isCameFomSearchPlaying = false
                                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                                searching = false
                                self.duaTableView.reloadData()

                                
                            }
                  
                            
                            
                        }
                        
                        else{
                            strPlayName = arr.name as? String ?? ""
                           isPlayingOutside = true
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                        }

                        
                    }
                    

                }
                
                else{
                    
                    let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    print(searchArrEng[tag].name,searchArrEng[tag].file)
                    
                    let arr = searchArrEng[tag]
                    strPlayName = arr.name as? String ?? ""
                    searchStr = ""
                    searchBar.searchTextField.text = ""
                    isCameFomSearch = true
                    searching = false
                    
                    isCameFomSearchPlaying = true
//                    spiner.isHidden = false
//                    spiner.startAnimating()
                    fetchMusicUrl(with: musicIdx,and: cell)
                    // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                    isPlayingOutside = true
                    self.duaTableView.reloadData()
                    // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                    
                }
            }
            else{
                
                if isPlayingOutside == true{
                    let tag = sender.tag as? Int ?? 0
                    UserDefaults.standard.setValue(tag, forKey: "Prev")
                    prevIdx = tag
                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    let arr = duaList[tag]
                    UserDefaults.standard.setValue(true, forKey: "isPlaying")
                    print(duaList[tag].name,duaList[tag].file)
                    cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    isPlayingOutside = false
                    ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                    if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                        strPlayName = arr.name as? String ?? ""
//                        UserDefaults.standard.setValue(false, forKey: "Current")
                        if UserDefaults.standard.value(forKey: "Current") as? Bool ?? false{
                            let val =  UserDefaults.standard.value(forKey: "CurrentIdx") as? Int ?? 0
                            print(val)
                            if val != tag {
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = true
                                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                                UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                                fetchMusicUrl(with: musicIdx,and: cell)
                                UserDefaults.standard.setValue(true, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                            }else{
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = true
                                player?.pause()
                                UserDefaults.standard.setValue(false, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                UserDefaults.standard.setValue(false, forKey: "isPlaying")
                                
                            }
                          
                        }
                        else{
                            
                            
                            strPlayName = arr.name as? String ?? ""
                            isPlayingOutside = true
                            UserDefaults.standard.setValue(true, forKey: "isPlaying")
                            UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                        }

                       
                    }
                    
                    else{
                        strPlayName = arr.name as? String ?? ""
                        isPlayingOutside = true
                        player?.pause()
                    }
                   
                }
                else{
                    let tag = sender.tag as? Int ?? 0
                    musicIdx = tag
                    prevIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    let arr = duaList[tag]
                    strPlayName = arr.name as? String ?? ""
                    print(duaList[tag].name,duaList[tag].file)
                    spiner.isHidden = false
                    spiner.startAnimating()
                    isPlayingOutside = true
                    isCameFomSearch = false
                    fetchMusicUrl(with: musicIdx,and: cell)
                    // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                   
                    // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                    
                }
            }
            
            
        }
       else if self.strLang == "हिंदी"{
           if (searching ?? false){
               if isPlayingOutside == true{
                   let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                   let idx = IndexPath(row: tag, section: 0)
                   let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                   print(searchArrHind[tag].name,searchArrHind[tag].file)
                   cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
//                    isPlayingOutside = false
//                    UserDefaults.standard.setValue(tag, forKey: "PrevSea")
                   let arr = searchArrHind[tag]
//                    strPlayName = arr.name as? String ?? ""
                 
                   ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                   
                   
//                    if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                   if strPlayName == arr.name as? String ?? ""{
                       
                       let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                       if (val == true)
                       {
                       strPlayName = arr.name as? String ?? ""
                       isPlayingOutside = false
                       player?.pause()
                       UserDefaults.standard.setValue(false, forKey: "Current")
                       UserDefaults.standard.removeObject(forKey: "Prev")
                       UserDefaults.standard.setValue(false, forKey: "isPlaying")
//                        self.duaTableView.reloadData()
                           
                           searchStr = ""
                           searchBar.searchTextField.text = ""
                           isCameFomSearch = false
                           isCameFomSearchPlaying = false
                           searching = false
                           self.duaTableView.reloadData()
                           
                           
                       }
                       
                       else{
                           strPlayName = arr.name as? String ?? ""
                          isPlayingOutside = true
                           fetchMusicUrl(with: musicIdx,and: cell)
                           UserDefaults.standard.setValue(true, forKey: "Current")
                           UserDefaults.standard.removeObject(forKey: "Prev")
                           searchStr = ""
                           searchBar.searchTextField.text = ""
                           isCameFomSearch = false
                           isCameFomSearchPlaying = false
                           searching = false
                           self.duaTableView.reloadData()
                       }

                      
                   }
                   
                   
                   else{
                       
                       let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                       if (val == true)
                       {
                           if strPlayName == arr.name as? String ?? ""{
                               strPlayName = arr.name as? String ?? ""
                               isPlayingOutside = false
                               player?.pause()
                               UserDefaults.standard.setValue(false, forKey: "Current")
                               UserDefaults.standard.removeObject(forKey: "Prev")
                               UserDefaults.standard.setValue(false, forKey: "isPlaying")
       //                        self.duaTableView.reloadData()
                                   
                                   searchStr = ""
                                   searchBar.searchTextField.text = ""
                                   isCameFomSearch = false
                                   isCameFomSearchPlaying = false
                                   searching = false
                                   self.duaTableView.reloadData()
                           }
                           
                           else{
                               strPlayName = arr.name as? String ?? ""
                              isPlayingOutside = true
                               fetchMusicUrl(with: musicIdx,and: cell)
//                                UserDefaults.standard.setValue(true, forKey: "Current")
                               UserDefaults.standard.removeObject(forKey: "Prev")
                               searchStr = ""
                               searchBar.searchTextField.text = ""
                               isCameFomSearch = false
                               isCameFomSearchPlaying = false
                               UserDefaults.standard.setValue(true, forKey: "isPlaying")
                               searching = false
                               self.duaTableView.reloadData()

                               
                           }
                 
                           
                           
                       }
                       
                       else{
                           strPlayName = arr.name as? String ?? ""
                          isPlayingOutside = true
                           fetchMusicUrl(with: musicIdx,and: cell)
                           UserDefaults.standard.setValue(true, forKey: "Current")
                           UserDefaults.standard.removeObject(forKey: "Prev")
                           searchStr = ""
                           searchBar.searchTextField.text = ""
                           isCameFomSearch = false
                           isCameFomSearchPlaying = false
                           searching = false
                           self.duaTableView.reloadData()
                       }

                       
                   }
                   

               }
               
               else{
                   
                   let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                   let idx = IndexPath(row: tag, section: 0)
                   let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                   print(searchArrHind[tag].name,searchArrHind[tag].file)
                   
                   let arr = searchArrHind[tag]
                   strPlayName = arr.name as? String ?? ""
                   searchStr = ""
                   searchBar.searchTextField.text = ""
                   isCameFomSearch = true
                   searching = false
                   
                   isCameFomSearchPlaying = true
                   spiner.isHidden = false
                   spiner.startAnimating()
                   fetchMusicUrl(with: musicIdx,and: cell)
                   // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                   isPlayingOutside = true
                   self.duaTableView.reloadData()
                   // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                   
               }
           }
           else{
               
               if isPlayingOutside == true{
                   let tag = sender.tag as? Int ?? 0
                   UserDefaults.standard.setValue(tag, forKey: "Prev")
                   prevIdx = tag
                   musicIdx = tag
                   let idx = IndexPath(row: tag, section: 0)
                   let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                   let arr = Hindi_duaList[tag]
                   UserDefaults.standard.setValue(true, forKey: "isPlaying")
                   print(Hindi_duaList[tag].name,Hindi_duaList[tag].file)
                   cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                   isPlayingOutside = false
                   ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                   if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                       strPlayName = arr.name as? String ?? ""
//                        UserDefaults.standard.setValue(false, forKey: "Current")
                       if UserDefaults.standard.value(forKey: "Current") as? Bool ?? false{
                           let val =  UserDefaults.standard.value(forKey: "CurrentIdx") as? Int ?? 0
                           print(val)
                           if val != tag {
                               strPlayName = arr.name as? String ?? ""
                               isPlayingOutside = true
                               UserDefaults.standard.setValue(true, forKey: "isPlaying")
                               UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                               fetchMusicUrl(with: musicIdx,and: cell)
                               UserDefaults.standard.setValue(true, forKey: "Current")
                               UserDefaults.standard.removeObject(forKey: "Prev")
                           }else{
                               strPlayName = arr.name as? String ?? ""
                               isPlayingOutside = true
                               player?.pause()
                               UserDefaults.standard.setValue(false, forKey: "Current")
                               UserDefaults.standard.removeObject(forKey: "Prev")
                               UserDefaults.standard.setValue(false, forKey: "isPlaying")
                               
                           }
                         
                       }
                       else{
                           strPlayName = arr.name as? String ?? ""
                           isPlayingOutside = true
                           UserDefaults.standard.setValue(true, forKey: "isPlaying")
                           UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                           fetchMusicUrl(with: musicIdx,and: cell)
                           UserDefaults.standard.setValue(true, forKey: "Current")
                           UserDefaults.standard.removeObject(forKey: "Prev")
                       }

                      
                   }
                   
                   else{
                       strPlayName = arr.name as? String ?? ""
                       isPlayingOutside = true
                       player?.pause()
                   }
                  
               }
               else{
                   let tag = sender.tag as? Int ?? 0
                   musicIdx = tag
                   prevIdx = tag
                   let idx = IndexPath(row: tag, section: 0)
                   let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                   let arr = Hindi_duaList[tag]
                   strPlayName = arr.name as? String ?? ""
                   print(Hindi_duaList[tag].name,Hindi_duaList[tag].file)
                   spiner.isHidden = false
                   spiner.startAnimating()
                   isPlayingOutside = true
                   isCameFomSearch = false
                   fetchMusicUrl(with: musicIdx,and: cell)
                   // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                  
                   // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                   
               }
           }
           
           
        }
        
        
        else if self.strLang == "عربي"{
            if (searching ?? false){
                if isPlayingOutside == true{
                    let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    print(searchArrAra[tag].name,searchArrAra[tag].file)
                    cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
//                    isPlayingOutside = false
//                    UserDefaults.standard.setValue(tag, forKey: "PrevSea")
                    let arr = searchArrAra[tag]
//                    strPlayName = arr.name as? String ?? ""
                  
                    ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                    
                    
//                    if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                    if strPlayName == arr.name as? String ?? ""{
                        
                        let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                        if (val == true)
                        {
                        strPlayName = arr.name as? String ?? ""
                        isPlayingOutside = false
                        player?.pause()
                        UserDefaults.standard.setValue(false, forKey: "Current")
                        UserDefaults.standard.removeObject(forKey: "Prev")
                        UserDefaults.standard.setValue(false, forKey: "isPlaying")
//                        self.duaTableView.reloadData()
                            
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                            
                            
                        }
                        
                        else{
                            strPlayName = arr.name as? String ?? ""
                           isPlayingOutside = true
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                        }

                       
                    }
                    
                    
                    else{
                        
                        let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                        if (val == true)
                        {
                            if strPlayName == arr.name as? String ?? ""{
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = false
                                player?.pause()
                                UserDefaults.standard.setValue(false, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                UserDefaults.standard.setValue(false, forKey: "isPlaying")
        //                        self.duaTableView.reloadData()
                                    
                                    searchStr = ""
                                    searchBar.searchTextField.text = ""
                                    isCameFomSearch = false
                                    isCameFomSearchPlaying = false
                                    searching = false
                                    self.duaTableView.reloadData()
                            }
                            
                            else{
                                strPlayName = arr.name as? String ?? ""
                               isPlayingOutside = true
                                fetchMusicUrl(with: musicIdx,and: cell)
//                                UserDefaults.standard.setValue(true, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                searchStr = ""
                                searchBar.searchTextField.text = ""
                                isCameFomSearch = false
                                isCameFomSearchPlaying = false
                                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                                searching = false
                                self.duaTableView.reloadData()

                                
                            }
                  
                            
                            
                        }
                        
                        else{
                            strPlayName = arr.name as? String ?? ""
                           isPlayingOutside = true
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                        }

                        
                    }
                    

                }
                
                else{
                    
                    let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    print(searchArrAra[tag].name,searchArrAra[tag].file)
                    
                    let arr = searchArrAra[tag]
                    strPlayName = arr.name as? String ?? ""
                    searchStr = ""
                    searchBar.searchTextField.text = ""
                    isCameFomSearch = true
                    searching = false
                    
                    isCameFomSearchPlaying = true
                    spiner.isHidden = false
                    spiner.startAnimating()
                    fetchMusicUrl(with: musicIdx,and: cell)
                    // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                    isPlayingOutside = true
                    self.duaTableView.reloadData()
                    // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                    
                }
            }
            else{
                
                if isPlayingOutside == true{
                    let tag = sender.tag as? Int ?? 0
                    UserDefaults.standard.setValue(tag, forKey: "Prev")
                    prevIdx = tag
                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    let arr = Arabic_duaList[tag]
                    UserDefaults.standard.setValue(true, forKey: "isPlaying")
                    print(Arabic_duaList[tag].name,Arabic_duaList[tag].file)
                    cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    isPlayingOutside = false
                    ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                    if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                        strPlayName = arr.name as? String ?? ""
//                        UserDefaults.standard.setValue(false, forKey: "Current")
                        if UserDefaults.standard.value(forKey: "Current") as? Bool ?? false{
                            let val =  UserDefaults.standard.value(forKey: "CurrentIdx") as? Int ?? 0
                            print(val)
                            if val != tag {
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = true
                                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                                UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                                fetchMusicUrl(with: musicIdx,and: cell)
                                UserDefaults.standard.setValue(true, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                            }else{
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = true
                                player?.pause()
                                UserDefaults.standard.setValue(false, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                UserDefaults.standard.setValue(false, forKey: "isPlaying")
                                
                            }
                          
                        }
                        else{
                            strPlayName = arr.name as? String ?? ""
                            isPlayingOutside = true
                            UserDefaults.standard.setValue(true, forKey: "isPlaying")
                            UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                        }

                       
                    }
                    
                    else{
                        strPlayName = arr.name as? String ?? ""
                        isPlayingOutside = true
                        player?.pause()
                    }
                   
                }
                else{
                    let tag = sender.tag as? Int ?? 0
                    musicIdx = tag
                    prevIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    let arr = Arabic_duaList[tag]
                    strPlayName = arr.name as? String ?? ""
                    print(Arabic_duaList[tag].name,Arabic_duaList[tag].file)
                    spiner.isHidden = false
                    spiner.startAnimating()
                    isPlayingOutside = true
                    isCameFomSearch = false
                    fetchMusicUrl(with: musicIdx,and: cell)
                    // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                   
                    // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                    
                }
            }
            
        }
        
        else{
            if (searching ?? false){
                if isPlayingOutside == true{
                    let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    print(searchArrGuj[tag].name,searchArrGuj[tag].file)
                    cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
//                    isPlayingOutside = false
//                    UserDefaults.standard.setValue(tag, forKey: "PrevSea")
                    let arr = searchArrGuj[tag]
//                    strPlayName = arr.name as? String ?? ""
                  
                    ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                    
                    
//                    if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                    if strPlayName == arr.name as? String ?? ""{
                        
                        let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                        if (val == true)
                        {
                        strPlayName = arr.name as? String ?? ""
                        isPlayingOutside = false
                        player?.pause()
                        UserDefaults.standard.setValue(false, forKey: "Current")
                        UserDefaults.standard.removeObject(forKey: "Prev")
                        UserDefaults.standard.setValue(false, forKey: "isPlaying")
//                        self.duaTableView.reloadData()
                            
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                            
                            
                        }
                        
                        else{
                            strPlayName = arr.name as? String ?? ""
                           isPlayingOutside = true
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                        }

                       
                    }
                    
                    
                    else{
                        
                        let val =  UserDefaults.standard.value(forKey: "isPlaying") as? Bool ?? false
                        if (val == true)
                        {
                            if strPlayName == arr.name as? String ?? ""{
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = false
                                player?.pause()
                                UserDefaults.standard.setValue(false, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                UserDefaults.standard.setValue(false, forKey: "isPlaying")
        //                        self.duaTableView.reloadData()
                                    
                                    searchStr = ""
                                    searchBar.searchTextField.text = ""
                                    isCameFomSearch = false
                                    isCameFomSearchPlaying = false
                                    searching = false
                                    self.duaTableView.reloadData()
                            }
                            
                            else{
                                strPlayName = arr.name as? String ?? ""
                               isPlayingOutside = true
                                fetchMusicUrl(with: musicIdx,and: cell)
//                                UserDefaults.standard.setValue(true, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                searchStr = ""
                                searchBar.searchTextField.text = ""
                                isCameFomSearch = false
                                isCameFomSearchPlaying = false
                                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                                searching = false
                                self.duaTableView.reloadData()

                                
                            }
                  
                            
                            
                        }
                        
                        else{
                            strPlayName = arr.name as? String ?? ""
                           isPlayingOutside = true
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                            searchStr = ""
                            searchBar.searchTextField.text = ""
                            isCameFomSearch = false
                            isCameFomSearchPlaying = false
                            searching = false
                            self.duaTableView.reloadData()
                        }

                        
                    }
                    

                }
                
                else{
                    
                    let tag = sender.tag as? Int ?? 0
//                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    print(searchArrGuj[tag].name,searchArrGuj[tag].file)
                    
                    let arr = searchArrGuj[tag]
                    strPlayName = arr.name as? String ?? ""
                    searchStr = ""
                    searchBar.searchTextField.text = ""
                    isCameFomSearch = true
                    searching = false
                    
                    isCameFomSearchPlaying = true
                    spiner.isHidden = false
                    spiner.startAnimating()
                    fetchMusicUrl(with: musicIdx,and: cell)
                    // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                    isPlayingOutside = true
                    self.duaTableView.reloadData()
                    // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                    
                }
            }
            else{
                
                if isPlayingOutside == true{
                    let tag = sender.tag as? Int ?? 0
                    UserDefaults.standard.setValue(tag, forKey: "Prev")
                    prevIdx = tag
                    musicIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    let arr = Gujrati_duaList[tag]
                    UserDefaults.standard.setValue(true, forKey: "isPlaying")
                    print(Gujrati_duaList[tag].name,Gujrati_duaList[tag].file)
                    cell.playBtn.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                    isPlayingOutside = false
                    ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                    if tag == UserDefaults.standard.value(forKey: "Prev") as? Int ?? 0{
                        strPlayName = arr.name as? String ?? ""
//                        UserDefaults.standard.setValue(false, forKey: "Current")
                        if UserDefaults.standard.value(forKey: "Current") as? Bool ?? false{
                            let val =  UserDefaults.standard.value(forKey: "CurrentIdx") as? Int ?? 0
                            print(val)
                            if val != tag {
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = true
                                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                                UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                                fetchMusicUrl(with: musicIdx,and: cell)
                                UserDefaults.standard.setValue(true, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                            }else{
                                strPlayName = arr.name as? String ?? ""
                                isPlayingOutside = true
                                player?.pause()
                                UserDefaults.standard.setValue(false, forKey: "Current")
                                UserDefaults.standard.removeObject(forKey: "Prev")
                                UserDefaults.standard.setValue(false, forKey: "isPlaying")
                                
                            }
                          
                        }
                        else{
                            strPlayName = arr.name as? String ?? ""
                            isPlayingOutside = true
                            UserDefaults.standard.setValue(true, forKey: "isPlaying")
                            UserDefaults.standard.setValue(tag, forKey: "CurrentIdx")
                            fetchMusicUrl(with: musicIdx,and: cell)
                            UserDefaults.standard.setValue(true, forKey: "Current")
                            UserDefaults.standard.removeObject(forKey: "Prev")
                        }

                       
                    }
                    
                    else{
                        strPlayName = arr.name as? String ?? ""
                        isPlayingOutside = true
                        player?.pause()
                    }
                   
                }
                else{
                    let tag = sender.tag as? Int ?? 0
                    musicIdx = tag
                    prevIdx = tag
                    let idx = IndexPath(row: tag, section: 0)
                    let cell = duaTableView.cellForRow(at: idx) as! DuaTableViewCell
                    let arr = Gujrati_duaList[tag]
                    strPlayName = arr.name as? String ?? ""
                    print(Gujrati_duaList[tag].name,Gujrati_duaList[tag].file)
                    spiner.isHidden = false
                    spiner.startAnimating()
                    isPlayingOutside = true
                    isCameFomSearch = false
                    fetchMusicUrl(with: musicIdx,and: cell)
                    // cell.playButton.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                   
                    // ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                    
                }
            }
            
        }
    }
       
        
    }
    
extension DuaVC{
    
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
    
    /*
    func hijriApi(){
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
    }
     */
    func setupUI() {
        UIView.animate(withDuration: 10, delay: 0.01, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            var marqueeStyle = DefaultStyle()
            marqueeStyle.showFullText = true
            self.floatingLbl.style  = marqueeStyle
            self.floatingLbl.textColor = .white
            self.floatingLbl.font = .preferredFont(forTextStyle: .title1)
            self.floatingLbl.text =  DailyDuaVC.globalFloatinglable
        }, completion:  { _ in
            
        })
    }
    
    func fetchDuaList() {
        objSingleton.dua_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                print(response)
                if self.strLang == "English"{
                    self.duaList.removeAll()
                    self.duaList.append(contentsOf: response.english_dua ?? [])
                    if !(self.duaList.isEmpty){
                        if self.musicIdx<self.duaList.count{
                            let txt  = self.duaList[self.musicIdx].name as? String ?? ""
                            self.strPlayName = txt
                            self.setupMusicUI(url: self.duaList[self.musicIdx].file as? String ?? "", str: txt)
                        }
                       
                    }
                    self.duaTableView.reloadData()
                }
                else if self.strLang == "हिंदी"{
                    self.Hindi_duaList.removeAll()
                    self.Hindi_duaList.append(contentsOf: response.hindi_dua ?? [])
                    if !(self.Hindi_duaList.isEmpty){
                        
                        if self.musicIdx<self.Hindi_duaList.count{
                            let txt  = self.Hindi_duaList[self.musicIdx].name as? String ?? ""
                            self.strPlayName = txt
                            self.setupMusicUI(url: self.Hindi_duaList[self.musicIdx].file as? String ?? "", str: txt)
                            
                        }
                        self.duaTableView.reloadData()
                    }
                   
                }
                else if self.strLang == "عربي"{
                    self.Arabic_duaList.removeAll()
                    self.Arabic_duaList.append(contentsOf: response.arabic_dua ?? [])
                    if !(self.Arabic_duaList.isEmpty){
                        if self.musicIdx<self.Arabic_duaList.count{
                            let txt  = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                            self.strPlayName = txt
                            self.setupMusicUI(url: self.Arabic_duaList[self.musicIdx].file as? String ?? "", str: txt)
                        }
                        self.duaTableView.reloadData()
                    }
                    
                }
                else{
                    self.Gujrati_duaList.removeAll()
                    self.Gujrati_duaList.append(contentsOf: response.gujrati_dua ?? [])
                    if !(self.Gujrati_duaList.isEmpty){
                        if self.musicIdx<self.Gujrati_duaList.count{
                            let txt  = self.Gujrati_duaList[self.musicIdx].name as? String ?? ""
                            self.strPlayName = txt
                            self.setupMusicUI(url: self.Gujrati_duaList[self.musicIdx].file as? String ?? "", str: txt)
                        }
                        self.duaTableView.reloadData()
                    }
                    
                }
                self.spiner.isHidden = true
                self.spiner.stopAnimating()
            }
        }, onError: { message in
            print(message as Any)
        })
    }
    
    func fetchFavDuaList() {
        objSingleton.dua_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                
                print(response)
                if self.strLang == "English"{
                    self.duaList.removeAll()
                    self.duaList.append(contentsOf: response.english_dua ?? [])
                 
                    self.duaTableView.reloadData()
                }
                else if self.strLang == "हिंदी"{
                    self.Hindi_duaList.removeAll()
                    self.Hindi_duaList.append(contentsOf: response.hindi_dua ?? [])
                    if !(self.Hindi_duaList.isEmpty){
                        
                     
                        self.duaTableView.reloadData()
                    }
                   
                }
                else if self.strLang == "عربي"{
                    self.Arabic_duaList.removeAll()
                    self.Arabic_duaList.append(contentsOf: response.arabic_dua ?? [])
                    if !(self.Arabic_duaList.isEmpty){
                       
                        self.duaTableView.reloadData()
                    }
                    
                }
                else{
                    self.Gujrati_duaList.removeAll()
                    self.Gujrati_duaList.append(contentsOf: response.gujrati_dua ?? [])
                    if !(self.Arabic_duaList.isEmpty){
                        self.duaTableView.reloadData()
                    }
                }

                
                self.spiner.isHidden = true
                self.spiner.stopAnimating()
                

            }
        }, onError: { message in
            print(message as Any)
        })
    }

    func fetchMusicUrl(with idx:Int) {
        var url = ""
        objSingleton.dua_List_API(onSuccess: { response in
            DispatchQueue.main.async {
                if self.strLang == "English"{
//                    self.duaList.removeAll()
//                    self.duaList.append(contentsOf: response.english_dua ?? [])
                    if self.musicIdx<self.duaList.count{
                        self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                        for i in 0..<self.duaList.count{
                            if self.strPlayName == self.duaList[i].name as? String ?? ""{
                                let txt  = self.duaList[i].name as? String ?? ""
                                self.audioLbl.text = txt
                                self.musicIdx = i
                                self.strPlayName = txt
                                self.setupMusicUI(url: self.duaList[i].file as? String ?? "", str: txt)
                                self.duaTableView.reloadData()
                                break
                            }
                        }
                       
                    }
                }
                else if self.strLang == "हिंदी"{
                    self.Hindi_duaList.removeAll()
                    self.Hindi_duaList.append(contentsOf: response.hindi_dua ?? [])
                    if self.musicIdx<self.Hindi_duaList.count{
                        self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                        for i in 0..<self.Hindi_duaList.count{
                            if self.strPlayName == self.Hindi_duaList[i].name as? String ?? ""{
                                let txt  = self.Hindi_duaList[i].name as? String ?? ""
                                self.audioLbl.text = txt
                                self.musicIdx = i
                                self.strPlayName = txt
                                self.setupMusicUI(url: self.Hindi_duaList[i].file as? String ?? "", str: txt)
                                self.duaTableView.reloadData()
                                break
                            }
                        }
                    }
                }
                else if self.strLang == "عربي"{
                    DispatchQueue.main.async {
                        
                        
                        self.Arabic_duaList.removeAll()
                        
                        self.Arabic_duaList.append(contentsOf: response.arabic_dua ?? [])
                        if self.musicIdx<self.Arabic_duaList.count{
                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                            for i in 0..<self.Arabic_duaList.count{
                                if self.strPlayName == self.Arabic_duaList[i].name as? String ?? ""{
                                    let txt  = self.Arabic_duaList[i].name as? String ?? ""
                                    self.audioLbl.text = txt
                                    self.musicIdx = i
                                    self.strPlayName = txt
                                    self.setupMusicUI(url: self.Arabic_duaList[i].file as? String ?? "", str: txt)
                                    self.duaTableView.reloadData()
                                    break
                                }
                            }
                            
                            
                        }
                    }
                    
                }
                else{
                    self.Gujrati_duaList.removeAll()
                    self.Gujrati_duaList.append(contentsOf: response.gujrati_dua ?? [])
                    if self.musicIdx<self.Gujrati_duaList.count{
                        self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                        for i in 0..<self.Gujrati_duaList.count{
                            if self.strPlayName == self.Arabic_duaList[i].name as? String ?? ""{
                                let txt  = self.Arabic_duaList[i].name as? String ?? ""
                                self.audioLbl.text = txt
                                self.musicIdx = i
                                self.strPlayName = txt
                                self.setupMusicUI(url: self.Arabic_duaList[i].file as? String ?? "", str: txt)
                                self.duaTableView.reloadData()
                                break
                            }
                        }
                    }
                    
                }

            }
        }, onError: { message in
            print(message as Any)
        })

    }
    
    func fetchMusicUrl(with idx:Int,and cell:DuaTableViewCell) {
        var url = ""
        let objSingleton = SingletonApi()
        objSingleton.dailyDuaListAPI(onSuccess: {response in
            print("Got Respose")
            print(response)
            print(response[0]["english_dua"].count)
            DispatchQueue.main.async {
                if response != nil {
                    
                    if self.strLang == "English"{
                        if (self.searching ?? false){
                            var arrdua = self.searchArrEng
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
//                                    if strPlayName == arrdua[idx].name as? String ?? ""{
//
//                                    }
                                    for i in self.duaList{
                                        if i.name as? String ?? "" == self.strPlayName {
                                            let txt  = arrdua[idx].name as? String ?? ""
                                            self.setupMusicUI(url: i.file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                        }
                                    }
                                    
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }
                        else{
                            
                            var arrdua = self.duaList
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    for i in 0..<self.duaList.count{
                                        if self.duaList[i].name as? String ?? "" == self.strPlayName {
                                            let txt  = self.duaList[i].name as? String ?? ""
                                            self.musicIdx = i
                                            self.setupMusicUI(url: self.duaList[i].file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                            break
                                        }
                                    }
                                    
                                    
//                                    let txt  = arrdua[idx].name as? String ?? ""
//                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
//                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }

//                        print(self.englishDuaList)
//                        self.dailyDuaTableView.reloadData()
                    }
                
                    else if self.strLang == "हिंदी"{
                        if (self.searching ?? false){
                            var arrdua = self.searchArrHind
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
//                                    if strPlayName == arrdua[idx].name as? String ?? ""{
//
//                                    }
                                    for i in self.duaList{
                                        if i.name as? String ?? "" == self.strPlayName {
                                            let txt  = arrdua[idx].name as? String ?? ""
                                            self.setupMusicUI(url: i.file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                        }
                                    }
                                    
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }
                        else{
                            var arrdua = self.Hindi_duaList
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    for i in 0..<self.Hindi_duaList.count{
                                        if self.Hindi_duaList[i].name as? String ?? "" == self.strPlayName {
                                            let txt  = self.Hindi_duaList[i].name as? String ?? ""
                                            self.musicIdx = i
                                            self.setupMusicUI(url: self.Hindi_duaList[i].file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                            break
                                        }
                                    }

                                    
//                                    let txt  = arrdua[idx].name as? String ?? ""
//                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
//                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }
                        
                    }
                    else if self.strLang == "عربي"{
                        if (self.searching ?? false){
                            var arrdua = self.searchArrAra
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
//                                    if strPlayName == arrdua[idx].name as? String ?? ""{
//
//                                    }
                                    for i in self.Arabic_duaList{
                                        if i.name as? String ?? "" == self.strPlayName {
                                            let txt  = arrdua[idx].name as? String ?? ""
                                            self.setupMusicUI(url: i.file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                        }
                                    }
                                    
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }
                        else{
                            var arrdua = self.Arabic_duaList
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    for i in 0..<self.Arabic_duaList.count{
                                        if self.Arabic_duaList[i].name as? String ?? "" == self.strPlayName {
                                            let txt  = self.Arabic_duaList[i].name as? String ?? ""
                                            self.musicIdx = i
                                            self.setupMusicUI(url: self.Arabic_duaList[i].file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                            break
                                        }
                                    }

                                    
//                                    let txt  = arrdua[idx].name as? String ?? ""
//                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
//                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }
                    }
                    else{
//                        var arrdua = self.Gujrati_duaList
//                        print(arrdua.count)
                        if (self.searching ?? false){
                            var arrdua = self.searchArrGuj
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
//                                    if strPlayName == arrdua[idx].name as? String ?? ""{
//
//                                    }
                                    for i in self.Gujrati_duaList{
                                        if i.name as? String ?? "" == self.strPlayName {
                                            let txt  = arrdua[idx].name as? String ?? ""
                                            self.setupMusicUI(url: i.file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                        }
                                    }
                                    
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }
                        else{
                            var arrdua = self.Gujrati_duaList
                            print(arrdua.count)
                            if idx<arrdua.count{
    //                            DispatchQueue.main.async {
    //                                url = arrdua[idx]["audio"]["url"].stringValue
                                
                                if self.isPlayingOutside == true{
                                    self.isCellMusicPlaying = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    for i in 0..<self.Gujrati_duaList.count{
                                        if self.Gujrati_duaList[i].name as? String ?? "" == self.strPlayName {
                                            let txt  = self.Gujrati_duaList[i].name as? String ?? ""
                                            self.musicIdx = i
                                            self.setupMusicUI(url: self.Gujrati_duaList[i].file as? String ?? "", str: txt)
                                            self.audioLbl.text = txt
                                            break
                                        }
                                    }

                                    
//                                    let txt  = arrdua[idx].name as? String ?? ""
//                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
//                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                    
                                }

                                else if self.isPlayingOutside == false{
                                    self.isCellMusicPlaying = true
    //                                self.isPlayingOutside = true
                                    self.ButtonPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    self.isCellMusicPlaying = true

                                    cell.playBtn.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                                    let txt  = arrdua[idx].name as? String ?? ""
                                    self.setupMusicUI(url: arrdua[idx].file as? String ?? "", str: txt)
                                    self.audioLbl.text = txt
                                    self.duaTableView.reloadData()
                                    self.spiner.isHidden = true
                                    self.spiner.stopAnimating()
                                }
                               
                            }
                            else{
                                self.musicIdx = arrdua.count-1
    //                            self.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                                print("no")
                            }
                        }
                    }
                    
                }
                else {
                    AlertMessageController.ShowAlert(title: AppName, messgae: "Please try again!", vc: self)
                }
            }
        }, onError: { message in
            print(message as Any)
        }
        )
       
    }
    
}
extension DuaVC{
    private func musicDelegate(){
        tfLang.inputView = langPicker
        langPicker.tag = 0
        pickerView.tag = 1
        langPicker.delegate = self
        langPicker.dataSource = self
        tfLang.text = strLang
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
    }
}
extension DuaVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
        if pickerView.tag == 0{
            self.musicIdx = 0
            strLang = arrLang[row]
            let langSender = strLang
            searching = false
            if langSender == "" {
            UserDefaults.standard.setValue("عربي", forKey: "GlobalStrLang")
            } else {
            UserDefaults.standard.setValue(langSender, forKey: "GlobalStrLang")
            }
//            UserDefaults.standard.setValue(false, forKey: "isPlaying")
//            UserDefaults.standard.setValue(false, forKey: "Current")
            UserDefaults.standard.removeObject(forKey: "Prev")
            UserDefaults.standard.removeObject(forKey: "Current")
            UserDefaults.standard.removeObject(forKey: "isPlaying")
            UserDefaults.standard.removeObject(forKey: "CurrentIdx")
            self.strPlayName = ""
            
            searchStr = ""
            searchBar.searchTextField.text = ""
            isCameFomSearch = false
            isCameFomSearchPlaying = false
            searching = false
            
            
            self.isPlayingOutside = false
            tfLang.text = arrLang[row]
            fetchDuaList()
            tfLang.resignFirstResponder()
            spiner.isHidden = false
            spiner.startAnimating()
        }
        else{
            switch row{
            case 0:
                speed = 0.50
                trackSpeed = speed
                player?.rate = trackSpeed
              //  globalSpeed = speed
               // player?.rate = globalSpeed
                pickerView.isHidden = true
               
            case 1:
                speed = 0.75
                globalSpeed = speed
                player?.rate = globalSpeed
                pickerView.isHidden = true
            case 2:
                speed = 1.0
                globalSpeed = speed
                player?.rate = globalSpeed
                pickerView.isHidden = true
            case 3:
                speed = 1.25
                globalSpeed = speed
                player?.rate = globalSpeed
                pickerView.isHidden = true
            case 4:
                speed = 1.50
                globalSpeed = speed
                player?.rate = globalSpeed
                pickerView.isHidden = true
            case 5 :
                speed = 1.75
                globalSpeed = speed
                player?.rate = globalSpeed
                pickerView.isHidden = true
            case 6:
                speed = 2.0
                globalSpeed = speed
                player?.rate = speed
                pickerView.isHidden = true
            case 7:
                speed = 4.0
                globalSpeed = speed
                player?.rate = globalSpeed
                pickerView.isHidden = true
            default:
                break
            }
        }
    }
    
    
}
extension DuaVC{
   
    func setupMusicUI(url:String,str:String) {
       searchArrEng.removeAll()
       var fetchedUrl = url
       guard let url = URL(string: fetchedUrl) else { return }
       let playerItem:AVPlayerItem = AVPlayerItem(url: url)
       player = AVPlayer(playerItem: playerItem)
        audio_Name = str
       let val = UserDefaults.standard.value(forKey: "speedUpadte") as? Float ?? 0.0
       player?.playImmediately(atRate: globalSpeed)
        
        
        UserDefaults.standard.setValue(true, forKey: "isPlaying")
//       duaTableView.reloadData()
        self.spiner.isHidden = true
        self.spiner.stopAnimating()
       self.isPlayingOutside = true
       self.isCellMusicPlaying = true
       self.audioLbl.text = str
        
       ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
       NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        
       //MARK: Add playback slider
        defultStr = str
        print(defultStr)
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
extension DuaVC{
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
extension DuaVC{
    @objc func updateSpeedLable(_ notif:Notification){
        //NotificationCenter.default.post(name: NSNotification.Name("speedUpadte"), object: nil, userInfo: ["Speed":speed])
        let val = notif.userInfo!["Speed"] as? Float ?? 0
        print(val)
        self.speed = val
        
       
    }
    
}

//MARK: LockScreen Playing
extension DuaVC {
    
    func playNext(){
        DispatchQueue.main.async {
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            print(self.musicIdx)
            self.musicIdx  = self.musicIdx + 1
            self.player?.rate = self.trackSpeed
            print(self.musicIdx)
            if self.strLang == "English"{
                if self.musicIdx < self.duaList.count{
                    self.strPlayName = self.duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }else{
                    self.musicIdx = self.duaList.count-1
                    self.strPlayName = self.duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }

            }
            else if self.strLang == "हिंदी"{
                if self.musicIdx < self.Hindi_duaList.count{
                    self.strPlayName = self.Hindi_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                else{
                    self.musicIdx = self.Hindi_duaList.count-1
                    self.strPlayName = self.Hindi_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                
                
                
            }
            else if self.strLang == "عربي"{
                if self.musicIdx < self.Arabic_duaList.count{
                    self.isPlayingOutside = true
                    self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                else{
                    self.musicIdx = self.Arabic_duaList.count-1
                    self.isPlayingOutside = true
                    self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                    
                }
                
            }
            else{
                if self.musicIdx < self.Gujrati_duaList.count{
                    self.isPlayingOutside = true
                    self.strPlayName = self.Gujrati_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                else{
                    self.musicIdx = self.Gujrati_duaList.count-1
                    self.isPlayingOutside = true
                    self.strPlayName = self.Gujrati_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                
            }
            
            self.isTapSound = true
        }
       
        
    }
    
    func playBack(){
        DispatchQueue.main.async {
            self.spiner.isHidden = false
            self.spiner.startAnimating()
            print(self.musicIdx)
            self.musicIdx -= 1
            print(self.musicIdx)
            if self.musicIdx >= 0{
                self.isTapSound = true
                if self.strLang == "English"{
                    self.strPlayName = self.duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                
                else if self.strLang == "हिंदी"{
                    self.strPlayName = self.Hindi_duaList[self.musicIdx].name as? String ?? ""
                   
//                    self.strPlayName = self.Hindi_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
    //                self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                    
                }
                else if self.strLang == "عربي"{
//                    self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
                    self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                    
                }
                else{
                    self.strPlayName = self.Gujrati_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
                    self.strPlayName = self.Gujrati_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                    
                }
                self.duaTableView.reloadData()
               
            }
            
            else{
                self.isPlayingOutside = true
                self.isTapSound = true
               // self.player?.rate = globalSpeed
                //self.player?.rate = self.trackSpeed
                self.musicIdx = 0
                
                if self.strLang == "English"{
                    self.strPlayName = self.duaList[self.musicIdx].name as? String ?? ""
//                    self.strPlayName = self.duaList[self.musicIdx].name as? String ?? ""
    //                strPlayName = arr.name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                }
                else if self.strLang == "हिंदी"{
                    self.strPlayName = self.Hindi_duaList[self.musicIdx].name as? String ?? ""
                   
//                    self.strPlayName = self.Hindi_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
    //                self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                    
                }
                else if self.strLang == "عربي"{
//                    self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
                    self.strPlayName = self.Arabic_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                    
                }
                else{
                    self.strPlayName = self.Gujrati_duaList[self.musicIdx].name as? String ?? ""
                    self.isPlayingOutside = true
                    self.strPlayName = self.Gujrati_duaList[self.musicIdx].name as? String ?? ""
                    self.searchStr = ""
                    self.searchBar.searchTextField.text = ""
                    self.isCameFomSearch = false
                    self.searching = false
                    self.searchArrAra.removeAll()
                    self.isCameFomSearchPlaying = false
                    self.fetchMusicUrl(with: self.musicIdx)
                    
                }
                print("Less than Zero")
                self.duaTableView.reloadData()
            }
        }
    }
    
    
}

extension DuaVC {
    
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
