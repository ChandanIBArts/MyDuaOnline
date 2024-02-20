//
//  DailyDuaTableViewCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import AVFoundation
import SwiftUI

class DailyDuaTableViewCell: UITableViewCell, AVAudioPlayerDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var audioFileNameLbl: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var durationLbl: UILabel!
    
    var audioUrl = ""
    var audioPlayer: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
//        if UITraitCollection.current.userInterfaceStyle == .dark{
//            self.sepratorView.layer.borderColor = UIColor.white.cgColor
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    func setupUI() {
        sepratorView.layer.cornerRadius = 20.0
        sepratorView.layer.borderWidth = 0.7
        sepratorView.layer.borderColor = UIColor(.black).cgColor
    }
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        print(audioUrl)
        /*
        let req = URLRequest(url: URL(string:audioUrl)!)
        let task = URLSession.shared.dataTask(with: req) { data, _, err in
            DispatchQueue.main.async {
                guard let data = data else {
                    print("can read data")
                    return
                }
                if let player = self.audioPlayer, player.isPlaying {
                    //Stop playback
                    self.playButton.setImage(UIImage(named: "play.png"), for: .normal)
                    player.stop()
                } else {
                    do {
                        self.playButton.setImage(UIImage(named: "pause.png"), for: .normal)
                        self.audioPlayer = try AVAudioPlayer(data: data)
                        guard let player = self.audioPlayer else{return}
                        player.play()
                        
                    } catch {
                        print(err?.localizedDescription as Any)
                        print("Player Stopped")
                    }
                }
            }
            
        }
        task.resume()
        */
    }
    
    @IBAction func downloadBtnTapped(_ sender: UIButton) {
        print(audioUrl)
        if let mp3URL = URL(string: audioUrl) {
            downloadMP3AndSave(url: mp3URL)
        }

      /*
        if let audioUrl = URL(string: audioUrl) {
            
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
            } else {
                URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                    guard let location = location, error == nil else { return }
                    do {
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch {
                        print(error)
                    }
                }.resume()
            }
        }
        */
        
    }
}


/*
func downloadFile(url: URL, completion: @escaping (URL?, Error?) -> Void) {
    let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }

        // Check if the response is an HTTP response with a status code indicating success
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let error = NSError(domain: "HTTPError", code: statusCode, userInfo: nil)
            completion(nil, error)
            return
        }

        // Move the temporary file to a permanent location if successful
        if let tempURL = tempURL {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

            do {
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                completion(destinationURL, nil)
            } catch {
                completion(nil, error)
            }
        }
    }

    task.resume()
}

func saveMP3ToDocumentsDirectory(fileURL: URL, completion: @escaping (Error?) -> Void) {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationURL = documentsDirectory.appendingPathComponent(fileURL.lastPathComponent)

    do {
        try FileManager.default.copyItem(at: fileURL, to: destinationURL)
        completion(nil)
    } catch {
        completion(error)
    }
}

// Example usage:
*/
func downloadMP3AndSave(url: URL) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error downloading MP3: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        // Replace "YourSong.mp3" with the desired name for the saved MP3 file
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent("YourSong.mp3")
        
        do {
            try data.write(to: destinationURL)
            print("MP3 file saved successfully at: \(destinationURL)")
        } catch {
            print("Error saving MP3 file: \(error.localizedDescription)")
        }
    }
    
    task.resume()
}
