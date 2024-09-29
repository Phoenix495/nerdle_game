//
//  NewGameView.swift
//  NerdleGame
//
    

import SwiftUI

struct NewGameView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppCoordinator.self) private var coordinator
    @State private var viewModel = NewGameViewModel()

    var body: some View {
        VStack {
            HStack { Spacer() }
            Text("Start New Game")
                .font(.title)
            Spacer()
            Text("Game mode:")
                .font(.title3)
            
            ForEach(GameSize.allCases, id: \.self) { size in
                Button(action: {
                    selectGameSize(size)
                }, label: {
                    Text(size.title)
                        .font(.callout)
                        .padding(.horizontal, 8)
                })
            }
            
            Spacer()
        }
        .padding()
        .background()
        .onAppear {
            viewModel.setup(with: context)
        }
    }
    
    private func selectGameSize(_ size: GameSize) {
        viewModel.createNewGame(with: size)
        if let game = viewModel.game {
            coordinator.push(.game(game))
        }
    }
}

#Preview {
    NewGameView()
}
