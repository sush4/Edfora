//
//  songPlayerViewController.swift
//  Edfora
//
//  Created by Sushant kumar on 18/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SongPlayerViewController: UIViewController {
    
    public var song:Song!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var playerToolbar: UIToolbar!
    var player : AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.configToolBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    MARK: ToolBar methods
    
    func rewindClicked() {
        if (self.player != nil) {
            if player.isPlaying {
                player.pause()
            }
            self.player.currentTime -= 5
            self.player.play()
        }
    }
    
    func playClicked() {
        
        if song.data.count > 0 {
            self.playSong()
        } else {
            self.downloadAudio()
        }
    }
    
    func puaseClicked() {
        if (self.player != nil) {
            self.player.pause()
        }
    }
    
    func stopClicked() {
        
        if (self.player != nil) {
            if player.isPlaying {
                player.pause()
            }
            player.currentTime = 0
            self.player.stop()
        }
    }
    
    func forwardClicked() {
        if (self.player != nil) {
            if player.isPlaying {
                player.pause()
            }
            self.player.currentTime += 5
            self.player.play()
        }
    }
    
//    MARK: Helper methods
    
    func configToolBar(){
        
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        )
        
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.rewind, target: self, action: #selector(SongPlayerViewController.rewindClicked))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action:nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action:  #selector(SongPlayerViewController.playClicked))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action:nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(SongPlayerViewController.puaseClicked))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action:nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(SongPlayerViewController.stopClicked))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action:nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fastForward, target: self, action: #selector(SongPlayerViewController.forwardClicked))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action:nil)
        )
        
        self.playerToolbar.tintColor = UIColor.black
        self.playerToolbar.items = items
    }
    
    func configView() {
        
        self.title = "Song Detail"
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.songName.text = self.song.name
        self.artistsLabel.text = "Artists : " + self.song.artists
        
        artistsLabel.font = UIFont(name: "Helvetica Neue", size: 16)
        songName.font = UIFont(name: "Helvetica Neue", size: 20)
        
        coverImage.contentMode = .scaleAspectFit
        
        if let checkedUrl = URL(string: song.coverImageURL) {
            downloadImage(url: checkedUrl)
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
            self.player.play()
        }
    }

}
