//
//  WebViewController.swift
//  Project16
//
//  Created by Joseph Van Alstyne on 9/12/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var capital: String!
    var websites: [String: String] = [
        "London": "https://en.wikipedia.org/wiki/London",
        "Oslo": "https://en.wikipedia.org/wiki/Oslo",
        "Paris": "https://en.wikipedia.org/wiki/Paris",
        "Rome": "https://en.wikipedia.org/wiki/Rome",
        "Washington DC": "https://en.wikipedia.org/wiki/Washington,_D.C.",
        "Tokyo": "https://en.wikipedia.org/wiki/Tokyo"
    ]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = capital
        navigationItem.largeTitleDisplayMode = .never
        
        let url = URL(string: websites[capital]!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }

}
