//
//  ViewController.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/12/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var search: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
        
        print("query", searchText)
        Query().query(query: searchText).send { (result) in
            print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // note these hard unwraps quick and dirty.
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

