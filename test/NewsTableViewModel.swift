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
import CoreData

class NewsTableViewModel {
    
    var reload = { () -> () in }
    
    var result: [News]? = [] {
        didSet {
            reload()
        }
    }
        
    func loadData(page: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
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
                            
                            let managedContext = appDelegate.persistentContainer.viewContext
                            let entity = NSEntityDescription.entity(forEntityName: "Newss", in: managedContext)!
                            let city = NSManagedObject(entity: entity, insertInto: managedContext)
                            city.setValue(item["title"]!, forKey: "title")
                            city.setValue(item["publishedAt"]!, forKey: "date")
                            city.setValue(item["url"]!, forKey: "link")
                            city.setValue(item["description"]!, forKey: "descr")
                            Utilites.shared().loadPic(url: item["urlToImage"]! as! String, completion: { (img:Data?) in
                                 city.setValue(img!, forKey: "img")
                            })
                            do {
                                try managedContext.save()
                            } catch let error as NSError {
                                print("\(error), \(error.userInfo)")
                            }

                        }
                    }
                } catch {
                    
                }
            case .failure( let error):
                NotificationCenter.default.post(name: .checkConnection, object: error.localizedDescription)
                Utilites.shared().loadDataFromCoreData(completion: { (result:AnyObject?) in
                    print(result!)
                })
            }
        }
    }
    
    
    
}
