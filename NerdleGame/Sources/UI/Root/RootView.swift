//
//  RootView.swift
//  NerdleGame
//
    

import SwiftUI

struct RootView: View {
    @State private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.paths) {
            coordinator.navigate(to: .main)
                .navigationDestination(for: Screen.self) { screen in
                    coordinator.navigate(to: screen)
                }
        }
        .environment(coordinator)
    }
}

#Preview {
    RootView()
}
