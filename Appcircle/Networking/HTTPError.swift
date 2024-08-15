//
//  HTTPError.swift
//  Appcircle
//
//  Created by Güven Karanfil on 2.08.2024.
//

import Foundation

enum HTTPError: Error {
    case failedResponse
    case failedDecoding
    case invalidUrl
    case invalidData
}
