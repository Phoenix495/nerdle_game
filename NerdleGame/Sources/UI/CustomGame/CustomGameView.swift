//
//  CustomGameView.swift
//  NerdleGame
//
    
import SwiftUI
import Combine

struct CustomGameView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppCoordinator.self) private var coordinator
    @State private var viewModel = CustomGameViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack { Spacer() }
            VStack {
                Text("Create Custom Game")
                    .font(.largeTitle)
                    .padding(.bottom, 8)
                
                Text("To create a new game with a custom equation please enter your equation below and press \"Create game\" button.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Form {
                    TextField("Equation", text: $viewModel.equationText)
                        .font(.headline)
                        .onChange(of: $viewModel.equationText.wrappedValue) { oldValue, newValue in
                            viewModel.handleEnterEquation(newValue)
                        }
                    
                    Picker(
                        "Game size",
                        selection: $viewModel.gameSize
                    ) {
                        ForEach(GameSize.allCases, id: \.self) { size in
                            Text(size.title)
                                .tag(size.rawValue)
                        }
                    }
                    .onChange(of: $viewModel.gameSize.wrappedValue) { oldValue, newValue in
                        viewModel.validateEquationAndGameSize()
                    }
                }
                .formStyle(.grouped)
                .scrollContentBackground(.hidden)
                
                Button(action: {
                    viewModel.createGame()
                }, label: {
                    Text("Create game")
                        .font(.title3)
                        .padding()
                })
                .disabled(!viewModel.canCreateGame)
                .onChange(of: $viewModel.newGame.wrappedValue) { oldValue, newValue in
                    if let game = newValue {
                        coordinator.push(.game(game))
                    }
                }
            }
        }
        .padding()
        .background()
        .onAppear {
            viewModel.setup(with: context)
        }
    }
}

#Preview {
    CustomGameView()
}
