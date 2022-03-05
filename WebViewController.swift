//
//  WebViewController.swift
//  Aurora
//
//  Created by AugursMacbook on 01/03/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    @IBOutlet weak var backBtn_Action: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var webUrl: URL?
    var url : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showAdded(to: view, animated: true)
        webUrl = URL(string: (url))
        let request = URLRequest(url: webUrl!)
        webView.load(request)
        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        MBProgressHUD.hide(for: self.view, animated: true)
    }
   
}
