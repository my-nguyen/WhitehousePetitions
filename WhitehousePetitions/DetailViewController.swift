//
//  DetailViewController.swift
//  WhitehousePetitions
//
//  Created by My Nguyen on 8/7/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: [String: String]!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // return immediately if detailItem is nil
        guard detailItem != nil else { return }

        // extract the value of "body"
        if let body = detailItem["body"] {
            var html = "<html>"
            html += "<head>"
            // fit the device width
            html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
            // set font size at 150% the standard size
            html += "<style> body { font-size: 150%; } </style>"
            html += "</head>"
            html += "<body>"
            html += body
            html += "</body>"
            html += "</html>"

            // display string in HTML format
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}

