//
//  Utilites.swift
//  test
//
//  Created by Egor Bryzgalov on 7/19/19.
//  Copyright © 2019 Egor Bryzgalov. All rights reserved.
//

import UIKit

class Utilites {
    
    private static var sharedUtilites: Utilites?
    
    private init() {}
    
    static func shared() -> Utilites {
        if sharedUtilites == nil {
            sharedUtilites = Utilites()
        }
        return sharedUtilites!
    }
    
    let newsPic = NSCache<AnyObject, AnyObject>()

    func loadPic(url: String, completion:@escaping(UIImage?) -> Swift.Void) {
        if url == "" {
            return
        }
        DispatchQueue.global().async {
            if let newsPic = self.newsPic.object(forKey: url as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    completion(newsPic)
                }
            } else {
                let link = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                if let data = try? Data(contentsOf: URL(string: link)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.newsPic.setObject(image as AnyObject, forKey: url as AnyObject)
                            completion(image)
                        }
                    }
                }
            }
        }
    }
    
    func convertTimeStamp(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dt = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.locale = tempLocale 
        let dateString = dateFormatter.string(from: dt)
        
        return dateString
    }
}

extension UIImageView {
    func loadFromURL(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
