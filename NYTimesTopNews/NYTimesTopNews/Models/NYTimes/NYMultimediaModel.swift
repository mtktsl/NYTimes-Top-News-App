//
//  NYMultimediaModel.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import Foundation

struct NYMultimediaModel: Decodable {
    let urlString: String?
    let format: String?
    let height: Int?
    let width: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case urlString = "url"
        case format
        case height
        case width
        case type
    }
}
