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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var search: UISearchBar!
    
    var searchAdaptor : SearchAdaptor? = nil
    let query = Query()
    var tableViewAdaptor : TableViewAdaptor! = nil
    var tableViewAdaptorSection : TableViewAdaptorSection<GiffyTableViewCell, GiffyData.Record>! = nil
    
    // the role of this view controller is largley to tie things together. They should be quite minimal,
    // to avoid mega view controller.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewAdaptorSection = TableViewAdaptorSection<GiffyTableViewCell, GiffyData.Record> (
            cellReuseIdentifier: "GiffyCell",
            sectionTitle: "",
            height: 30,
            items: [],
            select: { (model, index) in
                self.display(model)
            })
        { cell, model in
            cell.viewData = GiffyTableViewCell.ViewData(model: model)
        }
        
        tableViewAdaptor = TableViewAdaptor (
            tableView: tableView,
            sections: [tableViewAdaptorSection],
            didChangeHandler: { [unowned self] in
                self.tableView.reloadData()
            }
        )
        
        searchAdaptor = SearchAdaptor(searchView: search, parentView: view) {
            self.query.query(query: self.search?.text ?? "").send { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.process(data)
                    case .error(let error):
                        self.displayError(error)
                    }
                }
            }
        }
    }
    
    fileprivate func display(_ data: GiffyData.Record) {
        if let url = URL(string: data.images.original.url) {
            self.webView.loadRequest(URLRequest(url: url))
        }
    }
    
    fileprivate func process(_ data: (Data)) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.processInBackground(data)
        }
    }
    
    fileprivate func processInBackground(_ data: (Data)) {
        let result = GiffyData.process(data)
        DispatchQueue.main.async {
            switch result {
            case .success(let gifData):
                guard gifData.data.count >= 1 else {
                    return
                }
                
                // display first result right away
                self.display(gifData.data[0])
                
                self.tableViewAdaptorSection.items = gifData.data
                self.tableViewAdaptor.update()
            case .error(let error):
                self.displayError(error)
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

