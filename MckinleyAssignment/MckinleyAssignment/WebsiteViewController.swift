//
//  WebsiteViewController.swift
//  MckinleyAssignment
//
//  Created by Saurabh Borate on 17/01/20.
//  Copyright © 2020 Phynart. All rights reserved.
//

import UIKit
import WebKit
class WebsiteViewController: UIViewController ,WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    var activityIndicator : UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = UserDefaults.standard.value(forKey: "LoginToken") as! String
        let url = URL(string: "https://mckinleyrice.com?token=\(token)")!
        activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        activityIndicator?.center = self.view.center
        self.view.addSubview(activityIndicator!)
        self.view.bringSubviewToFront(activityIndicator!)
        activityIndicator?.color = .black
        self.activityIndicator?.startAnimating()
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator?.stopAnimating()
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
