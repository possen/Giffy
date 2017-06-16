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
        let parameters =   ["q" : query,
                            "api_key" : "dc6zaTOxFJmzC",
                            "limit": "\(limit)",
                            "offset": "\(offset)"]
        
        return  RESTNetworkRequest(command: "v1/gifs/search", parameters: parameters)
    }
}
