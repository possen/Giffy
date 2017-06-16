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
    
    let pageSize = 50
    var lastQuery = ""
    var searchAdaptor : SearchAdaptor? = nil
    let query = Query()
    var tableViewAdaptor : TableViewAdaptor! = nil
    var tableViewAdaptorSection : TableViewAdaptorSection<GiffyTableViewCell, GiffyModel.Record>! = nil
    
    // the role of this view controller is largley to tie things together. They should be quite minimal,
    // to avoid mega view controller.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewAdaptorSection = TableViewAdaptorSection<GiffyTableViewCell, GiffyModel.Record> (
            cellReuseIdentifier: "GiffyCell",
            sectionTitle: "",
            height: 100,
            items: [:],
            pageSize: pageSize,
            select: { (model, index) in
                if let model = model {
                    self.display(model)
                }
            },
            pageFault: { (offset) in
                self.perform(query:self.lastQuery, offset: offset, pageSize: self.pageSize)
            })
        { cell, model, index in
            if let model = model {
                cell.viewData = GiffyTableViewCell.ViewData(model: model, index: index)
            }
        }
        
        tableViewAdaptor = TableViewAdaptor (
            tableView: tableView,
            sections: [tableViewAdaptorSection],
            didChangeHandler: { [unowned self] in
                self.tableView.reloadData()
            }
        )
        
        searchAdaptor = SearchAdaptor(searchView: search, parentView: view) {
            self.performFresh(query:self.search?.text ?? "", offset: 0, pageSize: self.pageSize)
        }
    }
    
    fileprivate func performFresh(query: String, offset: Int, pageSize: Int) {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0) ?? 0 > 0 {
            tableView.scrollToRow(at: IndexPath(row:0, section:0), at: .top, animated: true)
        }
        lastQuery = query
        tableViewAdaptorSection.items = [:]
        perform(query: query, offset: offset, pageSize: pageSize)
    }
        
    fileprivate func perform(query: String, offset: Int, pageSize: Int) {
        return self.query.query(query: query, offset: offset, limit: pageSize).send { (result) in
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
    
    fileprivate func display(_ data: GiffyModel.Record) {
        if let url = URL(string: data.images.original.url) {
            self.webView.loadRequest(URLRequest(url: url))
        }
    }
    
    fileprivate func process(_ data: (Data)) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.processInBackground(data)
        }
    }
    
    fileprivate func setDataForRange(_ gifData: (GiffyModel)) {
        let dict = Dictionary(uniqueKeysWithValues: zip(gifData.pagination.offset..., gifData.data))
        
        // bug causes type inference problem, map works around the problem.
        // the problem: https://bugs.swift.org/browse/SR-4969
        self.tableViewAdaptorSection.items.merge(dict.lazy.map { ($0.key, $0.value) },
                                                 uniquingKeysWith: { (_, new) in new })
        self.tableViewAdaptor.update()
    }
    
    fileprivate func processInBackground(_ data: (Data)) {
        let result = GiffyModel.process(data)
        DispatchQueue.main.async {
            switch result {
            case .success(let gifData):
                guard gifData.data.count >= 1 else {
                    return
                }
                
                // display first result right away
                self.display(gifData.data[0])
                self.tableViewAdaptorSection.itemCount = gifData.pagination.total_count
                self.setDataForRange(gifData)
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
        alert.popoverPresentationController?.sourceView = search
        self.present(alert, animated: true, completion: {})
    }
}

