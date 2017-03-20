//
//  SongTableViewCell.swift
//  Edfora
//
//  Created by Sushant kumar on 18/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var downLoadButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    var player : AVAudioPlayer!
    
    var delegate : SongListViewDelegate!
    var song : Song!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        artistsLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        songName.font = UIFont(name: "Helvetica Neue", size: 16)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reConfigCell() {
        
        songName.text = song.name;
        artistsLabel.text = "Artists : " + song.artists
        
        let favImage = UIImage(named: "favourited")
        favouriteButton.setImage(favImage , for: UIControlState.normal)
        
        if song.favourite {
            favouriteButton.tintColor = UIColor.black
        } else {
             favouriteButton.tintColor = UIColor.lightGray
        }
        
        let playImage = UIImage(named: "play")
        playButton.setImage(playImage , for: UIControlState.normal)
        
        if (player != nil && player.isPlaying){
            playButton.tintColor = UIColor.black
        }
        else{
            playButton.tintColor = UIColor.lightGray
        }
        
        let downImage = UIImage(named: "download")
        downLoadButton.setImage(downImage , for: UIControlState.normal)
        
        if song.data.count > 0 {
            downLoadButton.tintColor = UIColor.black
        } else {
            downLoadButton.tintColor = UIColor.lightGray
        }
        
        if let checkedUrl = URL(string: song.coverImageURL) {
            downloadImage(url: checkedUrl)
        }
        //self.textLabel?.text = song.name
    }
    
    @IBAction func downloadClicked(_ sender: Any) {
            
        if let checkedUrl = URL(string: song.url) {
            
            ApiRequest.getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                self.song.data = data
                self.delegate.reloadCell(cell: self)
            }
        }
    }
    
    @IBAction func playClicked(_ sender: Any) {
        
        if song.data.count > 0 {
            self.playSong()
        } else {
            self.downloadAudio()
        }
    }
    
    @IBAction func favouriteClicked(_ sender: Any) {
        song.favourite = !song.favourite
        delegate.reloadCell(cell: self)
    }
    
    func downloadAudio()  {
        
        if let checkedUrl = URL(string: song.url) {
            
            ApiRequest.getDataFromUrl(url: checkedUrl) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                self.song.data = data
                self.playSong()
            }
        }
    }
    
    func playSong() {
        DispatchQueue.main.async() { () -> Void in
            
            if (self.player == nil){
                let session = AVAudioSession.sharedInstance()
                try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
                self.player = try! AVAudioPlayer(data: self.song.data)
                self.player.volume = 1.0
            }
            if self.player.isPlaying {
                self.player.pause()
            } else {
                self.player.play()
            }
            self.delegate.reloadCell(cell: self)
        }
    }
    
    func downloadImage(url: URL) {
        ApiRequest.getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.coverImage.image = UIImage(data: data)
            }
        }
    }
    
}
