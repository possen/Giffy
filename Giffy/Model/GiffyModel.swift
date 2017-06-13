//
//  GiffyModel.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/13/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

struct GiffyData: Decodable {
    struct Record: Decodable {
        struct Original : Decodable {
            let frames: String
            let url : String
        }
        
        struct Image: Decodable {
            let original : Original
        }
        
        let images: Image
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
}
