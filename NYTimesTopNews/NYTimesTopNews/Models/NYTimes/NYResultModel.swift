//
//  NYResultModel.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import Foundation

struct NYResultModel: Decodable {
    let title: String?
    let description: String?
    let author: String?
    let multimedia: [NYMultimediaModel]
    let urlString: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "abstract"
        case author = "byline"
        case multimedia
        case urlString = "short_url"
    }
}
