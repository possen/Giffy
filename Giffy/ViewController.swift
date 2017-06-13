//
//  ViewController.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/12/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var search: UISearchBar!
    var searchAdaptor : SearchAdaptor? = nil
    let query = Query()
    
    // the role of this view controller is largley to tie things together. They should be quite minimal,
    // to avoid mega view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        searchAdaptor = SearchAdaptor(searchView: search, parentView: view) {
            self.query.query(query: self.search?.text ?? "").send { (result) in
                print(result)
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        // note these hard unwraps quick and dirty.
                        // this also is not something that should be done in a view controller.
                        // I will also try the new swift 4 way for dealing with json data.
                        let d = data as! [String: Any]
                        let dict = d["data"] as! [[String: Any]]
                        let images = dict[0]["images"] as! [String: Any]
                        let original = images["original"] as! [String: Any]
                        let url = original["url"] as! String
                        print(url)
                        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
                    //                    self.image.loadImageAtURL(URL(string:url)!)
                    case .error(let error):
                        let alert = UIAlertController.init(title: "NetworkError", message: "error \(error)", preferredStyle: .actionSheet)
                        alert.show(self, sender: nil)
                    }
                }
            }
        }
    }
}

