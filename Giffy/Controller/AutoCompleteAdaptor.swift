//
//  AutoCompleteAdaptor.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/12/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class AutoCompleteAdaptor : NSObject, UITableViewDelegate, UITableViewDataSource {
    private var tableView : UITableView! = nil
    private var select : ((String) -> Void)? = nil
    var showControl = false
    
    // auto complete data would actually be held in a model object.
    private let autoCompleteData = [
        "about",
        "above",
        "across",
        "app",
        "apple",
        "appreciate",
        "bad",
        "ball",
        "balloon",
        "bell",
        "cat"]
    
    private var autoCompleteFiltered : [String]
    
    init(tableView: UITableView, select: @escaping (String) -> Void) {
        autoCompleteFiltered = autoCompleteData
        super.init()
        
        self.select = select
        self.tableView = tableView
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = autoCompleteFiltered[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        select?(autoCompleteFiltered[indexPath.row])
        showControl = false
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    func changed(text: String) {
        autoCompleteFiltered = autoCompleteData.filter({ (item) -> Bool in
            return item.hasPrefix(text.lowercased())
        })
        
        DispatchQueue.main.async {
            let count = self.autoCompleteFiltered.count
            self.showControl = count != 0
            let frame = self.tableView.frame
            let height = min(self.tableView.rowHeight * CGFloat(count), self.tableView.superview!.frame.size.height)
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height:height)
            self.update()
            self.tableView.reloadData()
        }
    }
    
    func update() {
        self.tableView.isHidden = !self.showControl
    }
}
