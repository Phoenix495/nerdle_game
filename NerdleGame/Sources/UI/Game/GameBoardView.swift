//
//  GameBoardView.swift
//  NerdleGame
//
    

import SwiftUI

struct GameBoardView: View {
    let size: GameSize
    @Binding var guesses: [Guess]
    
    var body: some View {
        Grid(alignment: .center, horizontalSpacing: 4, verticalSpacing: 4) {
            ForEach(0..<size.guesses, id: \.self) { row in
                let guess = getGuessIfExist(by: row)
                GridRow {
                    ForEach(0..<size.digits, id: \.self) { digit in
                        let char = getGuessChar(from: guess, by: digit)
                        GameBoardItem(guessChar: char)
                    }
                }
            }
        }
        .padding([.top, .horizontal])
    }
    
    private func getGuessIfExist(by index: Int) -> Guess? {
        guard !guesses.isEmpty else { return nil }
        if index < guesses.count {
            return guesses[index]
        }
        return nil
    }
    
    private func getGuessChar(from guess: Guess?, by index: Int) -> GuessChar? {
        guard let guess, !guess.charsSorted.isEmpty else { return nil }
        if index < guess.charsSorted.count {
            return guess.charsSorted[index]
        }
        return nil
    }
}

struct GameBoardItem: View {
    var guessChar: GuessChar? = GuessChar(symbol: "1", feedback: .wrongPosition)
    var body: some View {
        Text(guessChar?.symbol ?? "")
            .frame(width: 50, height: 50)
            .background(guessChar?.feedback?.color ?? .gray)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .font(.system(.title))
            .foregroundStyle(.white)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 2),
                    removal: .scale(scale: 0.5)
                )
            )
            .id("GuessChar_\(String(describing: guessChar?.feedback?.rawValue))")
    }
}

#Preview {
    GameBoardView(
        size: .classic,
        guesses: .constant([
            .init(chars: [
                .init(symbol: "1", feedback: .correct),
                .init(symbol: "2", feedback: .incorrect),
                .init(symbol: "+", feedback: .correct),
                .init(symbol: "4", feedback: .wrongPosition),
                .init(symbol: "5", feedback: .wrongPosition),
                .init(symbol: "=", feedback: .correct),
                .init(symbol: "2", feedback: .incorrect),
            ])
        ])
    )
}
