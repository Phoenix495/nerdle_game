//
//  MainView.swift
//  NerdleGame
//
    
import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppCoordinator.self) private var coordinator
    @State private var viewModel = MainViewModel()
    @State private var showCantStartNewGameAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack { Spacer() }
            
            Text("Nerdle Game")
                .font(.system(.largeTitle))
            
            Spacer()
            VStack(spacing: 12) {
                if let game = viewModel.getGameToContinue() {
                    Button("Continue game") {
                        coordinator.push(.game(game))
                    }
                }
                
                Button("New game") {
                    if viewModel.canStartNewGame() {
                        coordinator.push(.newGame)
                    } else {
                        showCantStartNewGameAlert.toggle()
                    }
                }
                .alert(
                    "You can create only one new game for the day!\nPlease return tomorrow and enjoy new Nerdle game.\n\n\n If you want you can replay your previous loosed or skipped games. You can find them in history.",
                    isPresented: $showCantStartNewGameAlert,
                    actions: {
                        Button("OK", role: .cancel) {}
                    }
                )
                
                Button("History") {
                    coordinator.push(.history)
                }
                
                Button("Custom game") {
                    coordinator.push(.customGame)
                }
                .padding(.top, 40)
            }
            Spacer()
        }
        .navigationTitle("Nerdle")
        .padding()
        .background()
        .onAppear {
            viewModel.setup(with: context)
        }
    }
}

#Preview {
    MainView()
}
