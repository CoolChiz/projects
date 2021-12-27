//
//  recipeApp_coredataApp.swift
//  recipeApp_coredata
//
//  Created by Duy on 12/4/21.
//

import SwiftUI

@main
struct recipeApp_coredataApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var data = RecipeApp()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(data)
        }
    }
}
