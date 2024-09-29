//
//  GameViewModel.swift
//  NerdleGame
//
    
import SwiftData
import SwiftUI
 
@Observable
final class GameViewModel {
    // MARK: - Public properties
    private(set) var game: Game?
    var guesses = [Guess]()
    var canSubmit = false
    var canDelete = false
    var gameResult: GameResult = .playing
    
    // MARK: - Private properties
    private(set) var guessIndex = 0
    private var dbContext: ModelContext?
    
    func setup(with context: ModelContext?, game: Game) {
        self.dbContext = context
        self.game = game
        self.guesses = game.guesses
        
        if !guesses.isEmpty {
            if guesses.last?.chars.allSatisfy({ $0.feedback != nil }) == true {
                guessIndex = guesses.count
            } else {
                guessIndex = guesses.count - 1
            }
        }
    }
    
    func handleKeyPressed(_ key: InputKeyType) {
        guard let game else { return }
        let guess: Guess
        if guessIndex < guesses.count {
            guess = guesses[guessIndex]
        } else {
            guess = .init()
        }
        
        switch key {
        case .enter:
            submitGuess(guess)
        case .delete:
            if !guess.chars.isEmpty {
                let char = guess.charsSorted.last
                guess.chars.removeAll(where: { $0.id == char?.id })
            }
        default:
            if guess.chars.count < game.gameSize.digits {
                let char = GuessChar(symbol: key.symbol)
                guess.chars.append(char)
            }
        }

        if let index = guesses.firstIndex(of: guess) {
            guesses.remove(at: index)
        }
        
        canSubmit = guess.chars.count == game.gameSize.digits
        canDelete = guess.chars.isEmpty == false
        guesses.append(guess)
        game.guesses = guesses
    }
    
    func submitGuess(_ guess: Guess) {
        guard let equationArray = game?.equation.split(separator: "").compactMap(String.init) else { return }
        
        for (index, char) in guess.charsSorted.enumerated() {
            let indices = equationArray.indices(of: char.symbol)
            withAnimation {
                if indices.isEmpty {
                    char.feedback = .incorrect
                } else {
                    char.feedback = indices.contains(index) ? .correct : .wrongPosition
                }
            }
        }
        
        guess.submitted = true
        guessIndex += 1;
        checkGameResult()
    }
    
    func checkGameResult() {
        guard let game else { return }
        let result = getGameResultFromGuess(guesses.last)
        if guessIndex < game.gameSize.guesses {
            game.result = result
        } else if result != .win {
            game.result = .loose
        }
        gameResult = game.result
    }
    
    private func getGameResultFromGuess(_ guess: Guess?) -> GameResult {
        guard let guess else { return .playing }
        return guess.chars.allSatisfy({ $0.feedback == .correct }) ? .win : .playing
    }
    
    func handleCloseGame() {
        if game?.result == .playing {
            game?.result = .skip
        }
        
        saveGame()
    }

    private func saveGame() {
        do {
            try dbContext?.save()
        } catch {
            print("save context failed with error:", error)
        }
    }
}
