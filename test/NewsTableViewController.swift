//
//  NewsTableViewController.swift
//  test
//
//  Created by Egor Bryzgalov on 7/19/19.
//  Copyright © 2019 Egor Bryzgalov. All rights reserved.
//

import UIKit
import Network

class NewsTableViewController: UITableViewController {

    let viewModel = NewsTableViewModel()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)
    let spinner = UIActivityIndicatorView(style: .gray)
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkConnection), name: .checkConnection, object: nil)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        viewModel.reload = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.loadData(page: page)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func checkConnection() {
        let alert = UIAlertController(title: "Error", message: "Connection Lost", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (UIAlertAction) in
            self.monitor.start(queue: self.queue)
        }))
        self.present(alert, animated: true, completion: nil)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.viewModel.loadData(page: self.page)
                self.monitor.cancel()
            } 
        }
        
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if page <= 4 {
            let currentOffset = scrollView.contentOffset.y
            let maxOffset = scrollView.contentSize.height - scrollView.frame.height
            if maxOffset - currentOffset <= 44 && viewModel.result!.count != 0 {
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width * 2, height: CGFloat(44))
                tableView.tableFooterView = self.spinner
                tableView.tableFooterView?.isHidden = false
                page += 1
                checkConnection()
                monitor.start(queue: queue)
                viewModel.loadData(page: page)
            }
        }
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.result?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell

        cell.titleLbl.text = viewModel.result?[indexPath.row].title ?? ""
        Utilites.shared().loadPic(url: viewModel.result?[indexPath.row].image ?? "q", completion: { (img:Data?) in
            cell.imgView.image = UIImage(data: img!)
        })
        
        return cell
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
        if segue.identifier == "showMore" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! NewsDescTableViewController
                destinationVC.news = viewModel.result![indexPath.row]
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
