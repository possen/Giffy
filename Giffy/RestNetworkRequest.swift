//
//  NetworkRequest.swift
//  Behance
//
//  Created by Paul Ossenbruggen on 11/30/15.
//  Copyright © 2015 Paul Ossenbruggen. All rights reserved.
//
// Description: Base class for Rest requests. Has appkey and keeps a base url
// manages the NSURLSession. 
//

import Foundation

enum CompletionData {
    case error(NSError)
    case success(AnyObject)
}

class RestNetworkRequest {
    fileprivate let baseUrl = URL(string: "http://api.giphy.com")
    fileprivate let command : String
    fileprivate var parameters : [String : String] = [:]
    
    init(command : String, parameters : [String : String]) {
        self.command = command
        self.parameters = parameters
    }

    func send(_ completion: @escaping (_ completion : CompletionData) -> Void) {
        let urlData = command + urlQuery + paramString
        let url = URL(string: urlData, relativeTo: baseUrl!)
        if let url = url {
            let request = URLRequest(url: url)
            print(request)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    self.processError(error as NSError?)
                    completion(CompletionData.error(error! as NSError))
                    return
                }
                let (result, error) = self.processResponseData(data)
                if let error = error {
                    completion(CompletionData.error(error))
                } else {
                    completion(CompletionData.success(result!))
                }
            }
            task.resume()
        }
    }
    
    fileprivate var urlQuery : String {
        return "?"
    }
    
    fileprivate var paramString : String {
        // converts params from dictionary to format of &key=value
        let string = parameters.reduce("") { $0 + "&\($1.0)=\($1.1)" }
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    fileprivate func processError(_ error : NSError?) {
        if let error = error {
            // generic error handling maybe for logging.
            print("network response error \(error)")
        }
    }

    fileprivate func parseJsonData(_ data : Data) -> (AnyObject?, NSError?) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String : AnyObject]
//            print(json)
            return (json as AnyObject?, nil)
        } catch let error as NSError {
            print("error serializing JSON: \(error)")
            return (nil, error)
        }
    }
    
    fileprivate func processResponseData(_ data : Data) -> (AnyObject?, NSError?) {
        return parseJsonData(data)
    }

}
