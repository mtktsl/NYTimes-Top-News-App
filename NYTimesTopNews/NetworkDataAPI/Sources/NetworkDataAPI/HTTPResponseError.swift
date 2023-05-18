//
//  File.swift
//  
//
//  Created by Metin Tarık Kiki on 18.05.2023.
//

import Foundation

public enum DataProviderServiceError: Error {
    case statusCode(code: Int)
    case emptyResponse
    case decodeError
    case unknown
}
