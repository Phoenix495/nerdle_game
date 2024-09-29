//
//  GameView.swift
//  NerdleGame
//
    

import SwiftUI

struct GameView: View {
    let game: Game
    @Environment(\.modelContext) private var context
    @Environment(AppCoordinator.self) private var coordinator: AppCoordinator
    @State private var viewModel = GameViewModel()
    @State private var showGameResultAlert = false

    var body: some View {
        VStack(spacing: 16) {
            HStack { Spacer() }
            Spacer()
            GameBoardView(
                size: game.gameSize,
                guesses: $viewModel.guesses
            )
            GameInputView(
                onKeyPressed: handleKeyPressed,
                enableEnter: $viewModel.canSubmit,
                enableDelete: $viewModel.canDelete
            )
            .onChange(of: $viewModel.gameResult.wrappedValue, { oldValue, newValue in
                showGameResultAlert = newValue != .playing
            })
            
            Spacer()
        }
        .background()
        .onDisappear {
            viewModel.handleCloseGame()
        }
        .onAppear {
            viewModel.setup(
                with: context,
                game: game
            )
        }
        .alert(
            getMessageForGameResult(viewModel.gameResult),
            isPresented: $showGameResultAlert
        ) {
            Button("Exit", role: .cancel) {
                coordinator.popToRoot()
            }
        }
        
    }
    
    private func handleKeyPressed(_ key: InputKeyType) {
        viewModel.handleKeyPressed(key)
    }
    
    private func getMessageForGameResult(_ result: GameResult) -> String {
        switch result {
        case .playing:
            ""
        case .skip:
            "You have skipped current game"
        case .loose:
            "Sorry!\nYou loose!"
        case .win:
            "Congratulations!\nGreat job!"
        }
    }
}

#Preview {
    GameView(game: .empty())
}
