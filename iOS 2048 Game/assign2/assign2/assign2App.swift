//
//  assign2App.swift
//  assign2
//
//  Created by Duy on 9/20/21.
//

import SwiftUI

@main
struct assign2App: App {
    @StateObject var twos = Twos()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(twos)
        }
    }
}
