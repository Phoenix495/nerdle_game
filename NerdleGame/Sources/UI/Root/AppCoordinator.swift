//
//  AppCoordinator.swift
//  NerdleGame
//
    

import SwiftUI

enum Screen: Hashable {
    case main
    case newGame
    case game(Game)
    case history
    case customGame
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

@Observable
class AppCoordinator {
    var paths = NavigationPath()
    var enableAnimation = true
    private var animate: Bool {
        enableAnimation
    }
    
    func push(_ screen: Screen) {
        withAnimation(.easeInOut(duration: animate ? 0.3 : 0)) {
            paths.append(screen)
        }
    }
    
    func pop() {
        if !paths.isEmpty {
            withAnimation(.easeInOut(duration: animate ? 0.3 : 0)) {
                paths.removeLast()
            }
        }
    }
    
    func popToRoot() {
        if !paths.isEmpty {
            withAnimation(.easeInOut(duration: animate ? 0.3 : 0)) {
                paths.removeLast(paths.count)
            }
        }
    }
    
    @ViewBuilder
    func navigate(to screen: Screen) -> some View {
        switch screen {
        case .main:
            MainView()
        case .newGame:
            NewGameView()
        case .game(let game):
            GameView(game: game)
        case .history:
            HistoryView()
        case .customGame:
            CustomGameView()
        }
    }
}
