//
//  news.swift
//  test
//
//  Created by Egor Bryzgalov on 7/19/19.
//  Copyright © 2019 Egor Bryzgalov. All rights reserved.
//

import Foundation

struct News {
    var title: String?
    var description: String?
    var date: String?
    var image: String?
    
    init() {}
    init(dict: Dictionary<String,AnyObject>) {
        if let _title = dict["title"] {
            self.title = _title as? String
        } else {
            self.title = ""
        }
        
        if let _desc = dict["description"] {
            self.description = _desc as? String
        } else {
            self.description = ""
        }
        
        if let _date = dict["publishedAt"] {
            self.date = _date as? String
        } else {
            self.date = ""
        }
        
        if let _image = dict["urlToImage"] {
            self.image = _image as? String
        } else {
            self.image = "none"
        }
    }
}
