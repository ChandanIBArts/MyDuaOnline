//
//  SahifaSajjadiaTableViewCell.swift
//  MyDua
//
//  Created by IB Arts Mac on 20/11/23.
//

import UIKit
import AVFoundation

class SahifaSajjadiaTableViewCell: UITableViewCell {

    @IBOutlet weak var sahifaTitleLbl: UILabel!
    @IBOutlet weak var favourtiteImage: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    var isTap = true
    var audioUrl = ""
    var audioPlayer: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupUI() {
        sepratorView.layer.cornerRadius = 20.0
        sepratorView.layer.borderWidth = 0.7
        sepratorView.layer.borderColor = UIColor(.black).cgColor
        favourtiteImage.image = UIImage(named: "unFavourite")
        favourtiteImage.isUserInteractionEnabled = true
        favourtiteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToFav)))
    }
    
    @objc func addToFav() {
         if isTap == false {
            favourtiteImage.image = UIImage(named: "unFavourite")
            isTap = true
        } else if isTap == true {
            favourtiteImage.image = UIImage(named: "favourite")?.withTintColor(UIColor.green)
            isTap = false
        }
    }
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        print(audioUrl)
        let req = URLRequest(url: URL(string:audioUrl)!)
        let task = URLSession.shared.dataTask(with: req) { data, _, err in
            DispatchQueue.main.async {
                guard let data = data else {
                    print("can read data")
                    return
                }
                if let player = self.audioPlayer, player.isPlaying {
                    //Stop playback
                    self.playBtn.setImage(UIImage(named: "play.png"), for: .normal)
                    player.stop()
                } else {
                    do {
                        self.playBtn.setImage(UIImage(named: "pause.png"), for: .normal)
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
    }
    
    @IBAction func downloadBtnTapped(_ sender: UIButton) {
        print("Download Tapped")
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
        
    }
    
}
