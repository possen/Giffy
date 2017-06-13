//
//  RestRequestManager.swift
//  Behance
//
//  Created by Paul Ossenbruggen on 11/30/15.
//  Copyright © 2015 Paul Ossenbruggen. All rights reserved.
//
// Manager for sending off rest requests
//

import Foundation

class RestRequestManager {
    func sendRequest(_ request : RestNetworkRequest, completion: @escaping (_ completionData : CompletionData) -> Void ) {
        request.send(completion)
    }
}
