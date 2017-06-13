//
//  SearchAdaptor.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/12/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class SearchAdaptor : NSObject, UISearchBarDelegate {
    var autoCompleteTableView : UITableView! = nil
    var autoCompleteAdaptor : AutoCompleteAdaptor! = nil
    var completion : (() -> Void)? = nil
    
    convenience init(searchView: UISearchBar,
                     parentView: UIView,
                     completion: @escaping () -> Void ) {
        self.init()
        
        self.completion = completion
        
        let tableFrame = CGRect(x: 0,
                                y: searchView.frame.size.height,
                                width: parentView.frame.size.width,
                                height: parentView.frame.size.height)
        
        autoCompleteTableView = UITableView(frame: tableFrame, style:.plain)
        
        autoCompleteAdaptor = AutoCompleteAdaptor(tableView: autoCompleteTableView) { text in
            self.queryChanged(searchBar: searchView, searchText: text)
        }
        
        autoCompleteTableView.isScrollEnabled = true
        autoCompleteTableView.isHidden = true
        autoCompleteTableView.alpha = 0.8
        searchView.delegate = self
        parentView.addSubview(autoCompleteTableView)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.completion?()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.queryChanged(searchBar: searchBar, searchText: searchText)
    }
    
    func queryChanged(searchBar: UISearchBar, searchText: String) {
        DispatchQueue.main.async {
            searchBar.text = searchText
            print("query", searchText)
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
                self.autoCompleteAdaptor.changed(text:searchText)
                DispatchQueue.main.async {
                    self.completion?()
                }
            }
        }
    }
}

