//
//  API.swift
//  Appcircle
//
//  Created by Güven Karanfil on 2.08.2024.
//

import Foundation

public class API {
    let apiConfig: APIConfig
    let apiFetcher: HTTPClient
    init(apiConfig: APIConfig, apiFetcher: HTTPClient) {
        self.apiConfig = apiConfig
        self.apiFetcher = apiFetcher
    }
}

