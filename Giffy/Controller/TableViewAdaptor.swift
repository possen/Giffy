//
//  TableViewAdaptor.swift
//
//  Created by Paul Ossenbruggen on 5/25/17.

import UIKit

protocol TableViewDataManagerDelegate : class {
    func update()
}

protocol TableSectionAdaptor {
    var cellReuseIdentifier: String { get }
    var title: String { get }
    var height : CGFloat { get }
    var itemCount : Int { get }
    var pageSize: Int { get }
    func select(index: Int)
    func configure(cell: UITableViewCell, index: Int)
}

class TableViewAdaptorSection<Cell, Model> : TableSectionAdaptor {
    internal let cellReuseIdentifier: String
    internal let title: String
    internal let height: CGFloat
    internal let pageSize: Int
    internal var items: [Int: Model] // sparse array
    
    init(cellReuseIdentifier : String,
         sectionTitle: String,
         height: CGFloat,
         items: [Int: Model],
         pageSize: Int, 
         select: @escaping ( Model?, Int) -> Void,
         pageFault: @escaping ( Int ) -> Void,
         configure: @escaping (Cell, Model?, Int) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.title = sectionTitle
        self.height = height
        self.items = items
        self.pageSize = pageSize
        self.configure = configure
        self.select = select
        self.pageFault = pageFault
    }
    
    internal var itemCount: Int = 0
    
    internal func select(index: Int) {
        select(items[index], index)
    }
    
    internal func configure(cell: UITableViewCell, index: Int) {
        configure(cell as! Cell, items[index], index ) // if this fails check IB cell is correct type, or reuse identifier is registered.
        internalPageFault(offset: index)
    }
    
    internal func internalPageFault(offset: Int) {
        if offset % pageSize == 0, items[offset] == nil {
            self.pageFault(offset)
        }
    }
    
    var configure: ( Cell, Model?, Int ) -> Void
    var select: ( Model?, Int ) -> Void
    var pageFault: ( Int ) -> Void
}


class TableViewAdaptor: NSObject, TableViewDataManagerDelegate {
    private let tableView: UITableView
    private let didChangeHandler: () -> Void
    let sections : [TableSectionAdaptor]
    
    init(tableView: UITableView,
         sections: [TableSectionAdaptor],
         didChangeHandler: @escaping () -> Void) {
        self.tableView = tableView
        self.didChangeHandler = didChangeHandler
        self.sections = sections
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func update() {
        DispatchQueue.main.async {
            self.didChangeHandler()
        }
    }
}

extension TableViewAdaptor : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier:section.cellReuseIdentifier, for: indexPath)
        section.configure(cell: cell, index: indexPath.row) // if this line fails, check that IB cellType is correct.
        return cell
    }
}

extension TableViewAdaptor : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? 20 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].itemCount != 0 ? 20 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].select(index: indexPath.row)
    }
}


