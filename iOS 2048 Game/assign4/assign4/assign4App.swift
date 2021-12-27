//
//  assign4App.swift
//  assign4
//
//  Created by Duy on 10/25/21.
//

import SwiftUI

@main
struct assign4App: App {
    let persistenceController = PersistenceController.shared
    @State var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(locationManager)
        }
    }
}
