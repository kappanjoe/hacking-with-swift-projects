//
//  DetailViewController.swift
//  Project38
//
//  Created by Joseph Van Alstyne on 12/8/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

	var detailItem: Commit?
	var webView: WKWebView!
	
	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		if let detail = self.detailItem {
			title = detail.message
			navigationItem.hidesBackButton = false
			navigationItem.largeTitleDisplayMode = .never
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .plain, target: self, action: #selector(showAuthorCommits))
			
			let url = URL(string: detail.url)!
			webView.load(URLRequest(url: url))
		}
    }
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		title = webView.title
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url
		let ac = UIAlertController(title: "Restricted Website", message: "Sorry, that website is blocked.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Return to Browser", style: .default, handler: nil))
		
		if let host = url?.host {
			if self.detailItem!.url.contains(host) {
				decisionHandler(.allow)
				return
			}
			present(ac, animated: true)
		}
		
		decisionHandler(.cancel)
	}
	
	@objc func showAuthorCommits() {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Author") as? AuthorViewController {
			vc.authorItem = self.detailItem?.author
			navigationController?.pushViewController(vc, animated: true)
		}
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
