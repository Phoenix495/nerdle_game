//
//  NerdleGameApp.swift
//  NerdleGame
//

import SwiftData
import SwiftUI

@main
struct NerdleGameApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(minWidth: 500, minHeight: 500)
        }
        .windowResizability(.contentSize)
        .modelContainer(for: [Game.self, Guess.self, GuessChar.self])
    }
}
