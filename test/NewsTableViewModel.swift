//
//  NewsTableViewModel.swift
//  test
//
//  Created by Egor Bryzgalov on 7/19/19.
//  Copyright © 2019 Egor Bryzgalov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsTableViewModel {
    
    var reload = { () -> () in }
    
    var result: [News]? = [] {
        didSet {
            reload()
        }
    }
        
    func loadData(page: Int) {
        let link = "https://newsapi.org/v2/everything?q=android&from=2019-04-00&sortBy=publishedAt&apiKey=26eddb253e7840f988aec61f2ece2907&page=\(String(page))"
        
        Alamofire.request(link, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                do {
                    let data = try json["articles"].rawData()
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [Dictionary<String, AnyObject>] {
                        for item in object {
                            self.result?.append(News(dict: item))
                        }
                    }
                } catch {
                    
                }
            case .failure( let error):
                NotificationCenter.default.post(name: .checkConnection, object: error.localizedDescription)
            }
        }
    }
    
    
    
}
