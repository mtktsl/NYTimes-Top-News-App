//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import Foundation

public enum DataProviderServiceError: Error {
    case statusCode(code: Int)
    case noResponse
    case decodeError
    case unknown
}
