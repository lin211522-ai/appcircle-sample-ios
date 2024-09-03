//
//  AppcircleApp.swift
//  Appcircle
//
//  Created by Mustafa on 29.12.2021.
//

import SwiftUI

@main
struct AppcircleApp: App {
    @State private var updateURL: URL?
    @State private var showAlert: Bool = false
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let updateChecker = UpdateChecker()
                    Task {
                        if let updateURL = try await updateChecker.checkForUpdate(organizationId: Environments.organizationId, secret: Environments.secret, profileId: Environments.profileId, storeURL: Environments.storeURL, userEmail: "USER_EMAIL") {
                            self.updateURL = updateURL
                            self.showAlert.toggle()
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Update Available"),
                        message: Text("A new version is available Would you like to update?"),
                        primaryButton: .default(Text("Update"), action: {
                            UIApplication.shared.open(self.updateURL!) { isOpened in
                                print("Application Opened")
                            }
                        }),
                        secondaryButton: .cancel(Text("Cancel"), action: {
                            // Handle the cancel action
                            print("User canceled the update")
                        })
                    )
                }
        }
    }
}
