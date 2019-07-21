//
//  WebViewController.swift
//  test
//
//  Created by Egor Bryzgalov on 7/21/19.
//  Copyright © 2019 Egor Bryzgalov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webVC: WKWebView!
    
    var link: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: link!)!
        webVC.load(URLRequest(url: url))
        webVC.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
