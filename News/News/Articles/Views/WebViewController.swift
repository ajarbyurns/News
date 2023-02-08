//
//  WebViewController.swift
//  News
//
//  Created by bitocto_Barry on 08/02/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var endpoint = ""
    let webView : WKWebView
    let refreshControl : UIRefreshControl

    init(_ url : String){
        self.endpoint = url
        webView = WKWebView()
        refreshControl = UIRefreshControl()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not in Storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: endpoint){
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.load(request)

        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        webView.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
        
    }
    
    @objc private func reload(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        webView.reload()
    }
    
}

extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      // Suppose you don't want your user to go a restricted site
      if let url = navigationAction.request.url {
          print(url.absoluteString)
      }
      decisionHandler(.allow)
    }
}
