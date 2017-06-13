//
//  ProjectsRequest.swift
//  Behance
//
//  Created by Paul Ossenbruggen on 11/30/15.
//  Copyright © 2015 Paul Ossenbruggen. All rights reserved.
//
// Description: Handles Project query.

import Foundation

class NetworkRequest : RestNetworkRequest {
    init(query : String?) {
        let parameters =   ["q" : query ?? "",
                            "api_key" : "dc6zaTOxFJmzC",
                            "limit": "1"]
        
        super.init(command: "v1/gifs/search", parameters:parameters)
    }
}
