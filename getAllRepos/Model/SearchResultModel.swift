//
//  SearchResultModel.swift
//  getAllRepos
//
//  Created by Mihai Dumitru on 07/03/2019.
//  Copyright © 2019 Mihai Dumitru. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    
    let totalCount: Int
    let items: [Repository]
    
    enum SearchResultCodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SearchResultCodingKeys.self)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        items = try container.decode([Repository].self, forKey: .items)
   }
}




