//
//  NYDefaultModel.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import Foundation

struct NYTopModel: Decodable {
    let numResults: Int
    let results: [NYResultModel]
    
    enum CodingKeys: String, CodingKey {
        case numResults = "num_results"
        case results
    }
}
