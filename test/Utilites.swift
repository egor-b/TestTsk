//
//  Utilites.swift
//  test
//
//  Created by Egor Bryzgalov on 7/19/19.
//  Copyright © 2019 Egor Bryzgalov. All rights reserved.
//

import UIKit
import CoreData

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

    func loadPic(url: String, completion:@escaping(Data?) -> Swift.Void) {
        if url == "" {
            return
        }
        DispatchQueue.global().async {
            if let newsPic = self.newsPic.object(forKey: url as AnyObject) as? Data {
                DispatchQueue.main.async {
                    completion(newsPic)
                }
            } else {
                let link = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                if let data = try? Data(contentsOf: URL(string: link)!) {
                    DispatchQueue.main.async {
                        self.newsPic.setObject(data as AnyObject, forKey: url as AnyObject)
                        completion(data)
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
    
    func loadDataFromCoreData(completion:@escaping(AnyObject?) -> Swift.Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Newss")
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(result as AnyObject)
        } catch let error as NSError {
            completion("\(error), \(error.userInfo)" as AnyObject)
        }
    }
}

extension Notification.Name {
    static let checkConnection = Notification.Name("checkConnection")
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
