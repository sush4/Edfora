//
//  ViewController.swift
//  Edfora
//
//  Created by Sushant kumar on 18/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit

protocol SongListViewDelegate {
    func reloadCell(cell:SongTableViewCell)
}

class SongListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource, SongListViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var songTableView: UITableView!
    var songList : Array<Song> = []
    var songListForView : Array<Song> = []
    @IBOutlet weak var favButton: UIButton!
    var favList : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.bottom
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Edfora"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.configSongTableView()
        
        self.favButton.titleLabel?.text = "Favourites"
        self.favButton.tintColor = UIColor.darkGray
        self.favButton.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        self.favButton.layer.borderWidth = 1
        
        searchBar.delegate = self as UISearchBarDelegate
        self.searchBar.placeholder = "Search By name"
        AppLogic.getSongList(completionHandler:displaySongList);
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    MARK: TABLEVIEW Delegates
    
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //            print(indexPath)
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let playerDetailViewController : PlayerDetailViewController = storyboard.instantiateViewController(withIdentifier: "PlayerDetailViewController") as! PlayerDetailViewController
//    playerDetailViewController.player = playerListForView[indexPath.row]
//    self.navigationController?.pushViewController(playerDetailViewController, animated: true);
    
    let songPlayerViewController : SongPlayerViewController = SongPlayerViewController()
    songPlayerViewController.song = songListForView[indexPath.row]
    self.navigationController?.pushViewController(songPlayerViewController, animated: true)
}

func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return songListForView.count
}

func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    let song : Song = songListForView[indexPath.row]
    cell.delegate = self as SongListViewDelegate
    cell.song = song
    cell.reConfigCell()
    
    return cell
    
}
    
//    MARK: SongListViewDelegate
    func reloadCell(cell: SongTableViewCell) {
        DispatchQueue.main.async {
            let indexPath = self.songTableView.indexPath(for: cell)
            self.songTableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
        }
    }
    
//    MARK: SearchBarDelegate
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    favList = false
    if searchText.characters.count > 0 {
        songListForView = songList.filter(){ $0.name.range(of: searchText, options: .caseInsensitive) != nil }
        self.reLoadTable()
    } else {
        songListForView = songList
        self.reLoadTable()
        self.searchBar.endEditing(true)
    }
    
}
    
    @IBAction func showFavList(_ sender: Any) {
        if favList {
            self.songListForView = songList
        } else {
            let filteredPlayerList = songList.filter() { $0.favourite == true }
            self.songListForView = filteredPlayerList
        }
        favList = !favList
        self.reLoadTable()
    }
    
//    MARK: Helper methods
    
    func configSongTableView() {
        
        songTableView.delegate = self as UITableViewDelegate
        songTableView.dataSource = self as UITableViewDataSource
        songTableView.tableFooterView = UIView(frame: CGRect.zero)
        songTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
    }
    
    func displaySongList(songList:Array<Song>) {
        self.songList = songList
        self.songListForView = songList
        self.reLoadTable()
    }

    func reLoadTable() {
        DispatchQueue.main.async(execute: {
            self.songTableView.reloadData()
        });
    }

}

