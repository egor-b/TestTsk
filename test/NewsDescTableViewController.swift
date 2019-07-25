//
//  NewsDescTableViewController.swift
//  test
//
//  Created by Egor Bryzgalov on 7/19/19.
//  Copyright © 2019 Egor Bryzgalov. All rights reserved.
//

import UIKit

class NewsDescTableViewController: UITableViewController {

    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Новость"
        let nib = UINib(nibName: "descriptionCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "descCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "descCell", for: indexPath) as! NewsDescTableViewCell
        
        cell.titleLbl.text = news?.title
        cell.descLbl.text = news?.description
        cell.date.text = Utilites.shared().convertTimeStamp(date: news!.date!)
        
        Utilites.shared().loadPic(url: news?.image ?? "none") { (img:Data?) in
            cell.imgView.image = UIImage(data: img!)
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "shoWeb", sender: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shoWeb" {
            let destVC = segue.destination as! WebViewController
            destVC.link = news?.link
//            if let indexPath = tableView.indexPathForSelectedRow {
//                
//            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
