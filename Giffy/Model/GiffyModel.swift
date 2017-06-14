//
//  GiffyModel.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/13/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

// Swift 4 decodable is quite nice.

struct GiffyData: Decodable {
    struct Record: Decodable {
        struct Original : Decodable {
            let frames: String?
            let url : String
        }
        
        struct Preview : Decodable {
            let url : String
        }
        
        struct Image: Decodable {
            let original : Preview
            let fixed_width_small : Original
        }
        
        let images: Image
        let slug: String
    }
    
    struct Pagination: Decodable {
        let count: Int
        let offset: Int
        let total_count: Int
    }
    
    struct Meta : Decodable {
        let msg: String
        let response_id: String
        let status: Int
    }
    
    let data: [Record]
    let meta: Meta
    let pagination: Pagination
    
    static func process(_ data: (Data)) -> CompletionData<GiffyData> {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(GiffyData.self, from: data)
            return CompletionData.success(result)
        } catch let error {
            return CompletionData.error(error)
        }
    }
}
