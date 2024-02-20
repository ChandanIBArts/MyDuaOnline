//
//  MusicPlay.swift
//  MyDua
//
//  Created by iB Arts Pvt. Ltd. on 23/01/24.
//

import Foundation
import AVFoundation
import UIKit

class MusicPlay{
    
    static var shared = MusicPlay()
    
    weak var vc1: FavouriteDuaVC?
    weak var vc2: SahifaSajjadiaFavVC?
    weak var vc3: ZiyaratFavVC?
    weak var vc4: SurahFavVC?
    weak var vc5: AllFavVC?
   
    
    
    //AllFavVC
    var duration: CMTime = CMTime(value: CMTimeValue(0), timescale: 0)
    var strStat = ""
    var index = 0
    var shareds = SingletonRemotControl.shareAPIdata
    var player: AVPlayer?
    
    private init(){}
    func setupMusicUI(url:String,str:String,tblView:UITableView,strStat:String,idx:Int,compl:@escaping (Bool)->Void) {
      
        self.strStat = strStat
        self.index = idx
        var fetchedUrl = url
        guard let url = URL(string: fetchedUrl) else {return}
        let playerItem:AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.playImmediately(atRate: 1.0)
        tblView.reloadData()
        compl(true)

       NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
       NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
      
        
       //MARK: Add playback slider
       duration = playerItem.asset.duration
       let seconds : Float64 = CMTimeGetSeconds(duration)
       let duration1 : CMTime = playerItem.currentTime()
       let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        switch strStat{
        case "Listen your favorite Dua":
            UserDefaults.standard.setValue(true, forKey: "isPlaying")
            vc1?.audioSlaider.minimumValue = globalSpeed
            vc1?.audioSlaider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
            vc1?.audioDurationLbl.text = self.stringFromTimeInterval(interval: seconds1)
            vc1?.audioSlaider.maximumValue = Float(seconds)
            vc1?.audioSlaider.isContinuous = true
            vc1?.audioSlaider.tintColor = UIColor.white
            
             player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
                 if self.player?.currentItem?.status == .readyToPlay {
                     let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                     vc1?.audioSlaider.value = Float ( time );
                     var reverseTime = CMTimeGetSeconds(duration) - time
                     vc1?.audioDurationLbl.text = self.stringFromTimeInterval(interval: reverseTime)
                 }
                 let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                 if playbackLikelyToKeepUp == false{
                     print("IsBuffering")
                     vc1?.btnPlay.isHidden = false
                 } else {
                     //stop the activity indicator
                     print("Buffering completed")
                     vc1?.btnPlay.isHidden = false
                 }
                 
             }
             
            
            break
        case "Listen your favorite Sahifa Sajjadia":
            vc2?.audioSlaider.minimumValue = globalSpeed
            vc2?.audioSlaider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
            vc2?.audioDurationLbl.text = self.stringFromTimeInterval(interval: seconds1)
            print(self.stringFromTimeInterval(interval: seconds1))
            vc2?.audioSlaider.maximumValue = Float(seconds)
            vc2?.audioSlaider.isContinuous = true
            vc2?.audioSlaider.tintColor = UIColor.white
            player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
                if self.player?.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    vc2?.audioSlaider.value = Float ( time );
                    var reverseTime = CMTimeGetSeconds(duration) - time
                    vc2?.audioDurationLbl.text = self.stringFromTimeInterval(interval: reverseTime)
                }
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    print("IsBuffering")
                    vc2?.btnPlay.isHidden = false
                } else {
                    //stop the activity indicator
                    print("Buffering completed")
                    vc2?.btnPlay.isHidden = false
                }
                
            }

            break
            
        case "Listen your favorite Ziyarat":
            vc3?.audioSlaider.minimumValue = globalSpeed
            vc3?.audioSlaider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
            UserDefaults.standard.setValue(true, forKey: "isPlaying")
            vc3?.audioDurationLbl.text = self.stringFromTimeInterval(interval: seconds1)
            print(self.stringFromTimeInterval(interval: seconds1))
            vc3?.audioSlaider.maximumValue = Float(seconds)
            vc3?.audioSlaider.isContinuous = true
            vc3?.audioSlaider.tintColor = UIColor.white
            vc3?.strPlayName = str
            vc3?.isPlayingOutside = true
            player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
                if self.player?.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    vc3?.audioSlaider.value = Float ( time );
                    var reverseTime = CMTimeGetSeconds(duration) - time
                    vc3?.audioDurationLbl.text = self.stringFromTimeInterval(interval: reverseTime)
                }
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    print("IsBuffering")
                    vc3?.btnPlay.isHidden = false
                } else {
                    //stop the activity indicator
                    print("Buffering completed")
                    vc3?.btnPlay.isHidden = false
                }
                
            }
            break
            
        case "Listen your favorite Surah":
            vc4?.audioSlaider.minimumValue = globalSpeed
            vc4?.audioSlaider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
            vc4?.audioDurationLbl.text = self.stringFromTimeInterval(interval: seconds1)
            print(self.stringFromTimeInterval(interval: seconds1))
            vc4?.audioSlaider.maximumValue = Float(seconds)
            vc4?.audioSlaider.isContinuous = true
            vc4?.audioSlaider.tintColor = UIColor.white
            player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
                if self.player?.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    vc4?.audioSlaider.value = Float ( time );
                    var reverseTime = CMTimeGetSeconds(duration) - time
                    vc4?.audioDurationLbl.text = self.stringFromTimeInterval(interval: reverseTime)
                }
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    print("IsBuffering")
                    vc4?.btnPlay.isHidden = false
                } else {
                    //stop the activity indicator
                    print("Buffering completed")
                    vc4?.btnPlay.isHidden = false
                }
                
            }
            break
        case "Listen your All favorite":
            vc5?.audioSlaider.minimumValue = globalSpeed
            vc5?.audioSlaider.addTarget(self, action: #selector(AudioDetailVC.playbackSliderValueChanged(_:)), for: .valueChanged)
            vc5?.audioDurationLbl.text = self.stringFromTimeInterval(interval: seconds1)
            print(self.stringFromTimeInterval(interval: seconds1))
            vc5?.audioSlaider.maximumValue = Float(seconds)
            vc5?.audioSlaider.isContinuous = true
            vc5?.audioSlaider.tintColor = UIColor.white
            player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [self] (CMTime) -> Void in
                if self.player?.currentItem?.status == .readyToPlay {
                    let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                    vc5?.audioSlaider.value = Float ( time );
                    
                    shareds.updateNowPlayingInfo(strTitle: str , duration: duration, playbackTime: Float64((vc5?.audioSlaider.value)!))
                    var reverseTime = CMTimeGetSeconds(duration) - time
                    vc5?.audioDurationLbl.text = self.stringFromTimeInterval(interval: reverseTime)
                }
                let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false{
                    print("IsBuffering")
                    vc5?.btnPlay.isHidden = false
                } else {
                    //stop the activity indicator
                    print("Buffering completed")
                    vc5?.btnPlay.isHidden = false
                }
                
            }
            break
            
        default:
            break
        }
        


       
   }
}

extension MusicPlay{
    //MARK: Fatch index wise
    func fetchMusicUrl(tblView:UITableView,strStat:String,idx:Int,compl:@escaping (String)->Void){
        
        switch strStat{
        case "Listen your favorite Dua":
            musicIdxPlay(tblView: tblView, vc: vc1, strStat: strStat, idx: idx){
                str in
                compl(str)
            }
            break
        case "Listen your favorite Sahifa Sajjadia":
            musicIdxPlay(tblView: tblView, vc: vc1, strStat: strStat, idx: idx){
                str in
                compl(str)
            }
            break
        case "Listen your favorite Ziyarat":
            musicIdxPlay(tblView: tblView, vc: vc1, strStat: strStat, idx: idx){
                str in
                compl(str)
            }
            break
        case "Listen your favorite Surah":
            musicIdxPlay(tblView: tblView, vc: vc1, strStat: strStat, idx: idx){
                str in
                compl(str)
            }
            break
        case "Listen your All favorite":
            musicIdxPlay(tblView: tblView, vc: vc1, strStat: strStat, idx: idx){
                str in
                compl(str)
            }
            break
            
        default:
            break
            
            
        }
        
        
    }
    
    

    //MARK: Fatch cell wise
    func fetchMusicForCell(with idx:Int,and cell:FavouriteTableViewCell,strPlayName:String,tblView:UITableView,compl:@escaping (String)->Void){
        let objSingleton = SingletonApi()
        switch strStat{
        case "Listen your favorite Dua":
            musics(idx: idx, cell: cell, strPlayName: strPlayName, tblView: tblView) { str in
                compl(str)
            }
            break
        case "Listen your favorite Sahifa Sajjadia":
            musics(idx: idx, cell: cell, strPlayName: strPlayName, tblView: tblView) { str in
                compl(str)
            }
            break
        case "Listen your favorite Ziyarat":
            musics(idx: idx, cell: cell, strPlayName: strPlayName, tblView: tblView) { str in
                compl(str)
            }
            break
        case "Listen your favorite Surah":
            musics(idx: idx, cell: cell, strPlayName: strPlayName, tblView: tblView) { str in
                compl(str)
            }
            break
        case "Listen your All favorite":
            musics(idx: idx, cell: cell, strPlayName: strPlayName, tblView: tblView) { str in
                compl(str)
            }
            break
            
        default:
            break
            
            
        }
        
 
        
    }
    
    private func musics(idx:Int,cell:FavouriteTableViewCell,strPlayName:String,tblView:UITableView,compl:@escaping (String)->Void){
        var arrdua = vc1?.arrFavList ?? []
        let objSingleton = SingletonApi()
        print(arrdua.count)
        switch strStat{
        case "Listen your favorite Dua":
        
            break
        case "Listen your favorite Sahifa Sajjadia":
            
             let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
             objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
                 DispatchQueue.main.async { [self] in
                     vc2?.arrFavList = response.arrayValue
                     let url = vc2?.arrFavList[idx]["file"].stringValue as? String ?? ""
                     let str = vc2?.arrFavList[idx]["name"].stringValue as? String ?? ""
                     self.setupMusicUI(url: url, str: str, tblView: tblView, strStat: strStat, idx: idx) { bool in
                         
                     }
                 }
             }, onError: { message in
                 print(message as Any)
             })

            break
        case "Listen your favorite Ziyarat":
            
             let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
             objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
                 DispatchQueue.main.async { [self] in
                     vc3?.arrFavList = response.arrayValue
                     let url = vc3?.arrFavList[idx]["file"].stringValue as? String ?? ""
                     let str = vc3?.arrFavList[idx]["name"].stringValue as? String ?? ""
                     self.setupMusicUI(url: url, str: str, tblView: tblView, strStat: strStat, idx: idx) { bool in
                         
                     }
                 }
             }, onError: { message in
                 print(message as Any)
             })
            break
        case "Listen your favorite Surah":
            
             let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
             objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
                 DispatchQueue.main.async { [self] in
                     vc4?.arrFavList = response.arrayValue
                     let url = vc4?.arrFavList[idx]["file"].stringValue as? String ?? ""
                     let str = vc4?.arrFavList[idx]["name"].stringValue as? String ?? ""
                     self.setupMusicUI(url: url, str: str, tblView: tblView, strStat: strStat, idx: idx) { bool in
                         
                     }
                 }
             }, onError: { message in
                 print(message as Any)
             })
            break
        case "Listen your All favorite":
            let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
            objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
                DispatchQueue.main.async { [self] in
                    vc5?.arrFavList = response.arrayValue
                    let url = vc5?.arrFavList[idx]["file"].stringValue as? String ?? ""
                    let str = vc5?.arrFavList[idx]["name"].stringValue as? String ?? ""
                    self.setupMusicUI(url: url, str: str, tblView: tblView, strStat: strStat, idx: idx) { bool in
                        
                    }
                }
            }, onError: { message in
                print(message as Any)
            })
            break
            
        default:
            break
            
            
        }

     
    }
    
    private func musicIdxPlay(tblView:UITableView,vc:UIViewController? = nil,strStat:String,idx:Int,compl:@escaping (String)->Void){
        let objSingleton = SingletonApi()
        let userId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        objSingleton.favDuaListDetailsAPI(userid: userId, onSuccess:{ response in
            DispatchQueue.main.async { [self] in
                
                
                switch strStat{
                case "Listen your favorite Dua":
                    
                    print(vc1?.arrFavList)
                    vc1?.arrFavList = response.arrayValue
                    let url = vc1?.arrFavList[idx]["file"].stringValue as? String ?? ""
                    let str = vc1?.arrFavList[idx]["name"].stringValue as? String ?? ""
                    
                    self.setupMusicUI(url: url, str: str, tblView: tblView,strStat: strStat, idx: idx) { bol in
                        compl(str)
                    }
                    break
                case "Listen your favorite Sahifa Sajjadia":
                    
                    print(vc2?.arrFavList)
                    vc2?.arrFavList = response.arrayValue
                    
                    let url = vc2?.arrFavList[idx]["file"].stringValue as? String ?? ""
                    let str = vc2?.arrFavList[idx]["name"].stringValue as? String ?? ""
                    self.setupMusicUI(url: url, str: str, tblView: tblView,strStat: strStat, idx: idx) { bol in
                        compl(str)
                    }
                    break

                case "Listen your favorite Ziyarat":
                    
                    print(vc3?.arrFavList)
                    vc3?.arrFavList = response.arrayValue
                    let url = vc3?.arrFavList[idx]["file"].stringValue as? String ?? ""
                    let str = vc3?.arrFavList[idx]["name"].stringValue as? String ?? ""
                    self.setupMusicUI(url: url, str: str, tblView: tblView,strStat: strStat, idx: idx) { bol in
                        compl(str)
                    }
                    break

                case "Listen your favorite Surah":
                    
                    print(vc4?.arrFavList)
                    vc4?.arrFavList = response.arrayValue
                    let url = vc4?.arrFavList[idx]["file"].stringValue as? String ?? ""
                    let str = vc4?.arrFavList[idx]["name"].stringValue as? String ?? ""
                    self.setupMusicUI(url: url, str: str, tblView: tblView,strStat: strStat, idx: idx) { bol in
                        compl(str)
                    }
                    break

                case "Listen your All favorite":
                    print(vc4?.arrFavList)
                    vc5?.arrFavList = response.arrayValue
                    let url = vc5?.arrFavList[idx]["file"].stringValue as? String ?? ""
                    let str = vc5?.arrFavList[idx]["name"].stringValue as? String ?? ""
                    self.setupMusicUI(url: url, str: str, tblView: tblView,strStat: strStat, idx: idx) { bol in
                        compl(str)
                    }
                    break
                    //            musicIdxPlay(tblView: tblView, vc: vc5, strStat: strStat, idx: idx)
                    break
                    
                default:
                    break
                    
                    
                }
                
                
            }
            
        }, onError: { message in
            
            print(message as Any)
        })
        
    }
}

extension MusicPlay{
    
    @objc private func playerDidFinishPlaying(_ notification: Notification) {
        playNext(index:self.index)
        }
   
    func playNext(index:Int) {
        var index = index
        
        switch strStat{
        case "Listen your favorite Dua":
                DispatchQueue.main.async { [self] in
                    index += 1
                    vc1?.spiner.isHidden = false
                    vc1?.spiner.startAnimating()
                    vc1?.isTapSound = true
                    vc1?.isPlayingOutside = true
                    vc1?.fetchMusicUrl(with: index)
                    print(self.index)
                }

            break
        case "Listen your favorite Sahifa Sajjadia":
            DispatchQueue.main.async { [self] in
                index += 1
                vc2?.spiner.isHidden = false
                vc2?.spiner.startAnimating()
                vc2?.isTapSound = true
                vc2?.isPlayingOutside = true
                vc2?.fetchMusicUrl(with: index)
                print(self.index)
            
            }
            break
            
        case "Listen your favorite Ziyarat":
                DispatchQueue.main.async { [self] in
                    index += 1
                    vc3?.spiner.isHidden = false
                    vc3?.spiner.startAnimating()
                    vc3?.isTapSound = true
                    vc3?.isPlayingOutside = true
                    vc3?.fetchMusicUrl(with: index)
                    print(self.index)
                }
            break
            
        case "Listen your favorite Surah":
                DispatchQueue.main.async { [self] in
                    index += 1
                    vc4?.spiner.isHidden = false
                    vc4?.spiner.startAnimating()
                    vc4?.isTapSound = true
                    vc4?.isPlayingOutside = true
                    vc4?.fetchMusicUrl(with: index)
                    print(self.index)
                }
            break
        case "Listen your All favorite":
            DispatchQueue.main.async { [self] in
                index += 1
                vc5?.spiner.isHidden = false
                vc5?.spiner.startAnimating()
                vc5?.isTapSound = true
                vc5?.isPlayingOutside = true
                vc5?.fetchMusicUrl(with: index)
                print(self.index)
            }
        break
            
        default:
            break
            
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
        switch strStat{
        case "Listen your favorite Dua":
                vc1?.btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            break
          case "Listen your favorite Sahifa Sajjadia":
                vc2?.btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            break
        case "Listen your favorite Ziyarat":
                vc3?.btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            break
        case "Listen your favorite Surah":
                vc4?.btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            break
        case "Listen your All favorite":
                vc5?.btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
            break
        default:
            break
            
        }
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
}

