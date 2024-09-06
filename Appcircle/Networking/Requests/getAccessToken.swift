//
//  getAccessToken.swift
//  Appcircle
//
//  Created by Güven Karanfil on 2.08.2024.
//

import Foundation

struct AuthModel: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
    }
}

extension API {
    func getAccessToken(secret: String, profileId: String) async throws -> AuthModel {
        var components = URLComponents()
        components.scheme = apiConfig.scheme
        components.host = apiConfig.host
        components.path = "/api/auth/token"
        
        guard let url = components.url else {
            throw HTTPError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = [
            "ProfileId": profileId,
            "Secret": secret
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        return try await apiFetcher.request(request: request)
    }
}
