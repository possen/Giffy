//
//  Query.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/12/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class Query {
    let request = RestRequestManager()

    func query(query: String) -> NetworkRequest {
       return  NetworkRequest(query: query)
    }
}
