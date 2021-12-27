//
//  assign3App.swift
//  assign3
//
//  Created by Duy on 10/3/21.
//

import SwiftUI

@main
struct assign3App: App {
    @StateObject var twos = Twos()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(twos)
        }
    }
}
