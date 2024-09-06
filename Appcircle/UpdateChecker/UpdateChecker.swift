//
//  UpdateChecker.swift
//  Appcircle
//
//  Created by Güven Karanfil on 2.08.2024.
//

import UIKit

public class UpdateChecker {
    private var authApiConfig: APIConfig
    private var authApiFetcher: APIFetcher
    private var authApi: API
    
    private var apiConfig: APIConfig
    private var apiFetcher: APIFetcher
    private var api: API
    
    init() {
        self.authApiConfig  = APIConfig(scheme: "https", host: Environments.storeURL)
        self.authApiFetcher = APIFetcher()
        self.authApi = API(apiConfig: self.authApiConfig, apiFetcher: self.authApiFetcher)
        
        self.apiConfig  = APIConfig(scheme: "https", host: "api.appcircle.io")
        self.apiFetcher = APIFetcher()
        self.api = API(apiConfig: self.authApiConfig, apiFetcher: self.authApiFetcher)
    }
    
    func checkForUpdate(secret: String, profileId: String, storeURL: String, userEmail: String) async throws -> URL? {
        do {
            let authResponse = try await self.authApi.getAccessToken(secret: secret, profileId: profileId)
            let appVersions = try await self.api.getAppVersions(accessToken: authResponse.accessToken)
            let bundle = Bundle.main
            let currentVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
            guard let currentVersion = currentVersion else {
                print("'CFBundleShortVersionString' Version Could Not found")
                return nil
            }
            
            guard let availableVersion = getLatestVersion(currentVersion: currentVersion, appVersions: appVersions) else {
                print("App is up to date!")
                return nil
            }
            
            guard let downloadURL  = URL(string: "itms-services://?action=download-manifest&url=https://\(storeURL)/api/app-versions/\(availableVersion.id)/download-version/\(authResponse.accessToken)/user/\(userEmail)") else {
                print("Latest Version URL could not created")
                return nil
            }
            
            return downloadURL
        } catch {
            print(error)
            return nil
        }
    }
    
    /*
        You can implement your custom update check mechanism within this function.
        Currently, we convert the version to an integer and compare it with the 'CFBundleShortVersionString'.
        You may want to check other datas about the app version to write the update control mechanism please check
        /v2/profiles/{profileId}/app-versions at https://api.appcircle.io/openapi/index.html?urls.primaryName=store
    */
    private func getLatestVersion(currentVersion: String, appVersions: [AppVersion]) -> AppVersion? {
        var latestAppVersion: AppVersion?
        let currentComponents = versionComponents(from: currentVersion)
        
        // Helper function to convert version string into an array of integers
        func versionComponents(from version: String) -> [Int] {
            return version.split(separator: ".").compactMap { Int($0) }
        }
        
        
        appVersions.forEach { app in
            // Convert versions to arrays of integers
            let latestComponents = versionComponents(from: app.version)
            
            // Compare versions component by component
            for (current, latest) in zip(currentComponents, latestComponents) {
                // You can control to update None, Beta or Live publish types you have selected on Appcircle Enterprise Store
                if (latest > current && app.publishType != 0) {
                    latestAppVersion = app
                }
                
            }
        }
        
        return latestAppVersion
    }
}
