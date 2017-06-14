//
//  TableViewCell.swift
//
//  Created by Paul Ossenbruggen on 5/26/17.
//
//

import UIKit
import Contacts

class GiffyTableViewCell: UITableViewCell {
    
    var title : String = ""
    var imageURL : URL? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle,  reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = UIImage(named: "Placeholder") ?? UIImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.clipsToBounds = true
        // make the imageView square
        let height = self.frame.size.height
        let size = height
        let textStart = self.frame.size.width - size - 4
        imageView?.frame = CGRect(x: 0, y: 0, width: size, height: size)
        textLabel?.frame = CGRect(x: size + 4, y: 0, width: textStart, height: height)
    }
    
    struct ViewData {
        let title: String
        let imageURL : URL?
    }
    
    var viewData: ViewData? {
        didSet {
            guard let viewData = viewData else {
                return
            }
            // if there is no name use the organization name, if both are
            // present set the detail on the cell.
            let title = viewData.title.trimmingCharacters(in: .whitespaces)
            var parts = title.split(separator: "-")
            parts.removeLast()
            let cleanTitle = String(parts.joined(separator: " "))
            textLabel!.text = cleanTitle.count == 0 ? "no title" : cleanTitle
            imageView?.contentMode = .scaleAspectFill
            if let imageURL = viewData.imageURL, let imageView = imageView {
                imageView.loadImageAtURL(imageURL)
            } else {
                imageView?.image = UIImage(named: "Placeholder") ?? UIImage()
            }
        }
    }
}

extension GiffyTableViewCell.ViewData {
    init(model: GiffyData.Record) {
        self.title = model.slug
        self.imageURL = URL(string: model.images.fixed_width_small.url)
    }
}

