//
//  getAppVersions.swift
//  Appcircle
//
//  Created by Güven Karanfil on 2.08.2024.
//

import Foundation

public struct AppVersion: Codable {
    let id: String
    let version: String
    let publishType: Int
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case id = "id"
        case publishType = "publishType"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        version = try container.decode(String.self, forKey: .version)
        publishType = try container.decode(Int.self, forKey: .publishType)
    }
}

extension API {
    func getAppVersions(accessToken: String, profileId: String) async throws -> [AppVersion] {
        var components = URLComponents()
        components.scheme = apiConfig.scheme
        components.host = apiConfig.host
        components.path = "/store/v2/profiles/\(profileId)/app-versions"
        guard let url = components.url else {
            throw HTTPError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        
        return try await apiFetcher.request(request: request)
    }
}
