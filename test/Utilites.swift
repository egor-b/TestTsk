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
    
    func loadDataFromCoreData(completion:@escaping(AnyObject?) -> Swift.Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(result as AnyObject)
        } catch let error as NSError {
            completion("\(error), \(error.userInfo)" as AnyObject)
        }
    }
    
    func cashDate() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "News", in: managedContext)!
        let city = NSManagedObject(entity: entity, insertInto: managedContext)
        city.setValue("", forKey: "name")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
