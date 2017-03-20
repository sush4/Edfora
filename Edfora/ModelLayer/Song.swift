//
//  Song.swift
//  Edfora
//
//  Created by Sushant kumar on 18/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit

class Song: NSObject {
    
    let name : String
    let url : String
    let artists : String
    let coverImageURL : String
    var data : Data
    var favourite : Bool
    
    override init() {
        name = ""
        url = ""
        artists = ""
        coverImageURL = ""
        data = Data()
        favourite = false
    }
    
    init(songDict:Dictionary<String, Any>){
        name = songDict["song"] as? String ?? ""
        url = songDict["url"] as? String ?? ""
        artists = songDict["artists"] as? String ?? ""
        coverImageURL = songDict["cover_image"] as? String ?? ""
        data = Data()
        favourite = false
    }
    

}
