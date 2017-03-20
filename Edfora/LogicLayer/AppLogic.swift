//
//  AppLogic.swift
//  Edfora
//
//  Created by Sushant kumar on 18/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import Foundation

class AppLogic {
    
    
    public static func getSongList(completionHandler:@escaping (Array<Song>) -> ()) {
  
        let url = "http://starlord.hackerearth.com/edfora/cokestudio"

        ApiRequest.makeGetRequest(urlPath: url) { (result) in
            parseResult(result: result, completionHandler: { (songList) in
                completionHandler(songList)
            })
        }
    }
    static func parseResult(result:Any, completionHandler:@escaping (Array<Song>) -> ()) {
        let resultArray = result as? Array<Any>
        var songArray = Array<Song>()
        
        for songDict in resultArray! {
            let song : Song = Song(songDict:songDict as! Dictionary<String, Any>)
            //            print(song.name, song.artists, song.url, song.coverimage)
            songArray.append(song)
        }
        completionHandler(songArray)
    }
    
}
