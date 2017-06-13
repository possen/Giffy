//
//  ViewController.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/12/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit
import WebKit

//let d = data as! [String: Any]
//let dict = d["data"] as! [[String: Any]]
//let images = dict[0]["images"] as! [String: Any]
//let original = images["original"] as! [String: Any]
//let url = original["url"] as! String
//print(url)



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
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let giffyResult = try decoder.decode(GiffyData.self, from: data)
                            let url = giffyResult.data[0].images.original.url
                            self.webView.loadRequest(URLRequest(url: URL(string: url)!))
                            //                    self.image.loadImageAtURL(URL(string:url)!)
                        } catch let error {
                            self.displayError(error)
                        }
                    case .error(let error):
                        self.displayError(error)
                    }
                }
            }
        }
    }
    
    fileprivate func displayError(_ error: (Error)) {
        print(error)
        let alert = UIAlertController(title: "NetworkError", message: "error \(error)", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {})
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {})
    }
    
}

