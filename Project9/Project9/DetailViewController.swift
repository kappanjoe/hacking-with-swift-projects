//
//  DetailViewController.swift
//  Project7
//
//  Created by Joseph Van Alstyne on 7/28/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 100%; font-family: Helvetica, sans-serif; margin-left: 18pt; margin-right: 14pt; } </style>
        </head>
        <body>
        <p><b>\(detailItem.title)</b></p>
        <p>\(detailItem.body)</p>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
    

}
