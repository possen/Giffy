//
//  Query.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/12/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class Query {
    func query(query: String, offset: Int, limit: Int) -> RESTNetworkRequest {
        let terms = query.replacingOccurrences(of: " ", with: "+")
        
        let parameters =   ["q" : terms,
                            "api_key" : "dc6zaTOxFJmzC",
                            "limit": "\(limit)",
                            "offset": "\(offset)"]
        
        return  RESTNetworkRequest(command: "v1/gifs/search", parameters: parameters)
    }
}
