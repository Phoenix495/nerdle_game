//
//  HistoryView.swift
//  NerdleGame
//
    
import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppCoordinator.self) private var coordinator
    
    @Query(
        sort: \Game.creationDate,
        order: .reverse
    )
    var games: [Game]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack { Spacer() }
            Text("Previous games:")
                .font(.largeTitle)
            if games.isEmpty {
                Spacer()
                Text("There is no games available")
                    .font(.largeTitle)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(games) { game in
                            GameHistoryView(
                                game: game,
                                action: {
                                    coordinator.push(.game(game))
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .background()
    }
}

struct GameHistoryView: View {
    let game: Game
    let action: () -> Void
    
    var body: some View {
        Button(action: action,
               label: {
            HStack {
                Text(game.creationDate, format: .relative(presentation: .named, unitsStyle: .wide))
                    .font(.title3)
                Spacer()
                Text(game.result.title)
                    .font(.callout)
                    .foregroundStyle(game.result.color)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        })
        .disabled(game.result == .win)
    }
}

#Preview {
    HistoryView()
}
