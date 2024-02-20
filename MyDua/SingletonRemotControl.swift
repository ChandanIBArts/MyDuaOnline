//
//  SingletonRemotControl.swift
//  MyDua
//
//  Created by IB Arts Mac on 24/01/24.
//

import Foundation
import AVFoundation
import MediaPlayer

class SingletonRemotControl {

    static var shareAPIdata = SingletonRemotControl()
    weak var dailyDuaVC: DailyDuaVC?
    weak var duaVC: DuaVC?
    weak var eventVC: EventVC?
    weak var safhiasajjadiaVC: SafhiaSajjadiaVC?
    weak var ziyaratVC: ZiyaratVC?
    weak var surahaVC: SurahVC?
    
    
    weak var myFavDuaVC: FavouriteDuaVC?
    weak var myFavSahifaSajjadiaVC:SahifaSajjadiaFavVC?
    weak var myFavZiyarat:ZiyaratFavVC?
    weak var myFavSurah:SurahFavVC?
    weak var myFavAllFav:AllFavVC?
    
    
    
//    var shared = SingletonRemotControl.shareAPIdata
    let commandCenter = MPRemoteCommandCenter.shared()
    var player: AVPlayer?
    
    func updateNowPlayingInfo(strTitle: String,duration: CMTime,playbackTime:Float64) {
       
        if globalControlerName == "DailyDuaVC" {
            
            var nowPlayingInfo = [String: Any]()
            print(globalName)
            // Set the title
            nowPlayingInfo[MPMediaItemPropertyTitle] = dailyDuaVC?.audio_Name
            
            let durationInSeconds =  CMTimeGetSeconds(duration)
            print(durationInSeconds)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackTime
            
            
            // Set the playback rate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = dailyDuaVC?.player?.rate
            
            // Set the now playing info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
        else if globalControlerName == "DuaVC" {
            
            var nowPlayingInfo = [String: Any]()
            
            // Set the title
            nowPlayingInfo[MPMediaItemPropertyTitle] = duaVC?.audio_Name
            
            let durationInSeconds =  CMTimeGetSeconds(duration)
            print(durationInSeconds)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackTime
            
            
            // Set the playback rate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = duaVC?.player?.rate
            
            // Set the now playing info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            
        }
        else if globalControlerName == "SafhiaSajjadiaVC" {
            
            var nowPlayingInfo = [String: Any]()
            
            // Set the title
            nowPlayingInfo[MPMediaItemPropertyTitle] = safhiasajjadiaVC?.audio_Name
            
            let durationInSeconds =  CMTimeGetSeconds(duration)
            print(durationInSeconds)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackTime
            
            
            // Set the playback rate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = safhiasajjadiaVC?.player?.rate
            
            // Set the now playing info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            
            
            
        }
        else if globalControlerName == "ZiyaratVC" {
            
            var nowPlayingInfo = [String: Any]()
            
            // Set the title
            nowPlayingInfo[MPMediaItemPropertyTitle] = ziyaratVC?.audio_Name
            
            let durationInSeconds =  CMTimeGetSeconds(duration)
            print(durationInSeconds)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackTime
            
            
            // Set the playback rate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = ziyaratVC?.player?.rate
            
            // Set the now playing info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            
            
        }
        else if globalControlerName == "SurahVC" {
            
            
            var nowPlayingInfo = [String: Any]()
            
            // Set the title
            nowPlayingInfo[MPMediaItemPropertyTitle] = surahaVC?.audio_Name
            
            let durationInSeconds =  CMTimeGetSeconds(duration)
            print(durationInSeconds)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackTime
            
            
            // Set the playback rate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = surahaVC?.player?.rate
            
            // Set the now playing info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            
        }
        else if globalControlerName == "EventVC" {
            
            var nowPlayingInfo = [String: Any]()
            print(globalName)
            // Set the title
            nowPlayingInfo[MPMediaItemPropertyTitle] = eventVC?.audio_Name
            
            let durationInSeconds =  CMTimeGetSeconds(duration)
            print(durationInSeconds)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackTime
            
            
            // Set the playback rate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = eventVC?.player?.rate
            
            // Set the now playing info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
        else if globalControlerName == "FavouriteDuaVC" {
            
            var nowPlayingInfo = [String: Any]()
            
            // Set the title
            nowPlayingInfo[MPMediaItemPropertyTitle] = myFavAllFav?.vc1?.audio_Name
            
            let durationInSeconds =  CMTimeGetSeconds(duration)
            print(durationInSeconds)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
            
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackTime
            
            
            // Set the playback rate
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = myFavAllFav?.player?.rate
            
            // Set the now playing info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            
            
        }
        
        
    }
    
    
    func setupRemoteTransportControls() {
        
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if globalControlerName == "DailyDuaVC" {
                dailyDuaVC?.player?.rate = globalSpeed
                dailyDuaVC?.player?.play()
                dailyDuaVC?.isPlayingOutside = true
                dailyDuaVC?.ButtonPlay.isHidden = true
                dailyDuaVC?.flag = true
                dailyDuaVC?.ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                dailyDuaVC?.dailyDuaTableView.reloadData()
            }
            else if globalControlerName == "DuaVC" {
                duaVC?.player?.rate = globalSpeed
                duaVC?.player?.play()
                duaVC?.isPlayingOutside = true
                duaVC?.ButtonPlay.isHidden = true
                duaVC?.flag = true
                duaVC?.ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                duaVC?.duaTableView.reloadData()
            }
            else if globalControlerName == "SafhiaSajjadiaVC" {
                safhiasajjadiaVC?.player?.rate = globalSpeed
                safhiasajjadiaVC?.player?.play()
                safhiasajjadiaVC?.isPlayingOutside = true
                safhiasajjadiaVC?.ButtonPlay.isHidden = true
                safhiasajjadiaVC?.flag = true
                safhiasajjadiaVC?.ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                safhiasajjadiaVC?.safhiaTableView.reloadData()
            }
            else if globalControlerName == "ZiyaratVC" {
                ziyaratVC?.player?.rate = globalSpeed
                ziyaratVC?.player?.play()
                ziyaratVC?.isPlayingOutside = true
                ziyaratVC?.ButtonPlay.isHidden = true
                ziyaratVC?.flag = true
                ziyaratVC?.ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                ziyaratVC?.ziyaratTableView.reloadData()
            }
            else if globalControlerName == "SurahVC" {
                surahaVC?.player?.rate = globalSpeed
                surahaVC?.player?.play()
                surahaVC?.isPlayingOutside = true
                surahaVC?.ButtonPlay.isHidden = true
                surahaVC?.flag = true
                surahaVC?.ButtonPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                surahaVC?.surahTableView.reloadData()
                
            }
            else if globalControlerName == "EventVC" {
                eventVC?.player?.rate = globalSpeed
                eventVC?.player?.play()
                eventVC?.isPlayingOutside = true
                eventVC?.btnPlay.isHidden = true
                eventVC?.flag = true
                eventVC?.btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                eventVC?.eventTableView.reloadData()
                        
            }
            else if globalControlerName == "FavouriteDuaVC"{
                myFavDuaVC?.player?.rate = globalSpeed
                myFavDuaVC?.player?.play()
                myFavDuaVC?.isPlayingOutside = true
                myFavDuaVC?.btnPlay.isHidden = true
                myFavDuaVC?.flag = true
                myFavDuaVC?.btnPlay.setImage(UIImage(named: "audio_pause"), for: UIControl.State.normal)
                UserDefaults.standard.setValue(true, forKey: "isPlaying")
                myFavDuaVC?.tblView.reloadData()
            }
            
            
            return .success
            return .commandFailed
        }

        //
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if globalControlerName == "DailyDuaVC" {
                dailyDuaVC?.player?.rate = globalSpeed
                dailyDuaVC?.player?.pause()
                dailyDuaVC?.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                dailyDuaVC?.isPlayingOutside = false
                dailyDuaVC?.flag = false
                dailyDuaVC?.dailyDuaTableView.reloadData()
//                return .success
//                return .commandFailed
            }
            else if globalControlerName == "DuaVC"{
                duaVC?.player?.rate = globalSpeed
                dailyDuaVC?.player?.rate = 0
                dailyDuaVC?.player?.pause()
                duaVC?.player?.pause()
                duaVC?.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                duaVC?.isPlayingOutside = false
                duaVC?.flag = false
                duaVC?.duaTableView.reloadData()
               
            }
            else if globalControlerName == "SafhiaSajjadiaVC" {
                safhiasajjadiaVC?.player?.rate = globalSpeed
                safhiasajjadiaVC?.player?.pause()
                safhiasajjadiaVC?.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                safhiasajjadiaVC?.isPlayingOutside = false
                safhiasajjadiaVC?.flag = false
                safhiasajjadiaVC?.safhiaTableView.reloadData()
//                return .success
//                return .commandFailed
            }
            else if globalControlerName == "ZiyaratVC" {
                ziyaratVC?.player?.rate = globalSpeed
                ziyaratVC?.player?.pause()
                ziyaratVC?.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                ziyaratVC?.isPlayingOutside = false
                ziyaratVC?.flag = false
                ziyaratVC?.ziyaratTableView.reloadData()
//                return .success
//                return .commandFailed
            } 
            else if globalControlerName == "SurahVC"{
                surahaVC?.player?.rate = globalSpeed
                surahaVC?.player?.pause()
                surahaVC?.ButtonPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                surahaVC?.isPlayingOutside = false
                surahaVC?.flag = false
                surahaVC?.surahTableView.reloadData()
//                return .success
//                return .commandFailed
                
            }
            else if globalControlerName == "EventVC" {
             
                eventVC?.player?.rate = globalSpeed
                eventVC?.player?.pause()
                eventVC?.btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                eventVC?.isPlayingOutside = false
                eventVC?.flag = false
                eventVC?.eventTableView.reloadData()
                        
            }
            else if globalControlerName == "FavouriteDuaVC"{
                myFavDuaVC?.player?.rate = globalSpeed
                myFavDuaVC?.player?.pause()
                myFavDuaVC?.btnPlay.setImage(UIImage(named: "audio_play"), for: UIControl.State.normal)
                myFavDuaVC?.isPlayingOutside = false
                myFavDuaVC?.flag = false
                myFavDuaVC?.tblView.reloadData()
            }
            return .success
            return .commandFailed
           
        }

        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            // Handle next track
            if globalControlerName == "DailyDuaVC" {
                dailyDuaVC?.playNext()
            }
            else if globalControlerName == "DuaVC" {
                duaVC?.playNext()
            }
            else if globalControlerName == "SafhiaSajjadiaVC" {
                safhiasajjadiaVC?.playNext()
            }
            else if globalControlerName == "ZiyaratVC" {
                ziyaratVC?.playNext()
            } 
            else if globalControlerName == "SurahVC" {
                surahaVC?.playNext()
            }
            else if globalControlerName == "EventVC" {
                eventVC?.playNext()
            }
            else if globalControlerName == "FavouriteDuaVC"{
                myFavDuaVC?.playNext()
            }
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            // Handle previous track
            if globalControlerName == "DailyDuaVC" {
                dailyDuaVC?.playBack()
            }
            else if globalControlerName == "DuaVC" {
                duaVC?.playBack()
            }
            else if globalControlerName == "SafhiaSajjadiaVC" {
                safhiasajjadiaVC?.playBack()
            }
            else if globalControlerName == "ZiyaratVC" {
                ziyaratVC?.playBack()
            }
            else if globalControlerName == "SurahVC" {
                surahaVC?.playNext()
            }
            else if globalControlerName == "EventVC" {
                        
                eventVC?.playBack()
            }
            else if globalControlerName == "FavouriteDuaVC"{
                myFavDuaVC?.playBack()
            }
            return .success
        }
    }
    
}
