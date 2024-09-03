//
//  APIFetcher.swift
//  Appcircle
//
//  Created by Güven Karanfil on 2.08.2024.
//

import Foundation

protocol HTTPClient {
    func request<T: Decodable>(request: URLRequest) async throws -> T
}

public class APIFetcher: HTTPClient {
    func request<T: Decodable>(request: URLRequest) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                guard let urlResponse = urlResponse as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                    continuation.resume(throwing: HTTPError.failedResponse)
                    return
                }

                guard let data = data else {
                    continuation.resume(throwing: HTTPError.invalidData)
                    return
                }

                do {
                    var convertedData = data
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let dataObject = jsonObject?["data"] {
                        convertedData = try JSONSerialization.data(withJSONObject: dataObject)
                    }
                    

                    let decodedData = try JSONDecoder().decode(T.self, from: convertedData)
                    continuation.resume(returning: decodedData)
                } catch {
                    continuation.resume(throwing: HTTPError.failedDecoding)
                }
            }.resume()
        }
    }
}
