//
//  NerdleGameTests.swift
//  NerdleGameTests
//

import SwiftData
import Testing
@testable import NerdleGame

struct NerdleGameTests {
    struct NewGameViewModelTests {
        private var sut: NewGameViewModel
        
        init() {
            sut = NewGameViewModel()
        }
        
        @Test(
            "Create New Game",
            arguments: GameSize.allCases
        )
        func createNewGame(_ size: GameSize) {
            sut.createNewGame(with: size)
            #expect(sut.game != nil, "Game created")
            #expect(sut.game?.gameSize == size, "Game size correct")
        }
        
        @Test(
            "Generate Equations with GameSize",
            arguments: GameSize.allCases
        )
        func generateEquation(_ size: GameSize) throws {
            let length = size.digits
            let equation = sut.generateRandomEquation(with: length)
            print("size: \(size), equation:", equation)
            #expect(equation.count == length, "Equation Size \(length)")
        }
    }
    
    struct GameViewModelTests {
        private var sut: GameViewModel
        
        init() {
            sut = GameViewModel()
            sut.setup(with: nil, game: .empty())
        }
        
        @Test(
            "Numbers add to current Guess",
            arguments: [
                InputKeyType.digit(0),
                InputKeyType.digit(1),
                InputKeyType.digit(2),
                InputKeyType.digit(3),
                InputKeyType.digit(4),
                InputKeyType.digit(5),
                InputKeyType.digit(6),
                InputKeyType.digit(7),
                InputKeyType.digit(8),
                InputKeyType.digit(9),
            ]
        )
        func numberAddingToCurrentGuess(_ key: InputKeyType) {
            sut.handleKeyPressed(key)
            let guessIndex = sut.guessIndex
            let currentGuessChars = sut.guesses[guessIndex].chars
            
            #expect(currentGuessChars.contains(where: { $0.symbol == key.symbol }))
        }
        
        @Test(
            "Operator add to current Guess",
            arguments: [
                InputKeyType.plus,
                InputKeyType.minus,
                InputKeyType.multiply,
                InputKeyType.divide,
                InputKeyType.equal,
            ]
        )
        func operatorsAddingToCurrentGuess(_ key: InputKeyType) {
            sut.handleKeyPressed(key)
            let guessIndex = sut.guessIndex
            let currentGuess = sut.guesses[guessIndex]
            
            #expect(sut.guesses.isEmpty == false)
            #expect(currentGuess.chars.isEmpty == false)
            #expect(currentGuess.chars.contains(where: { $0.symbol == key.symbol }))
        }
        
        @Test("Symbols deleted from current Guess")
        func symbolDeleteFromCurrentGuess() {
            sut.handleKeyPressed(.digit(1))
            sut.handleKeyPressed(.digit(2))
            sut.handleKeyPressed(.plus)
            sut.handleKeyPressed(.digit(3))
            sut.handleKeyPressed(.delete)
            sut.handleKeyPressed(.delete)
            
            let guessIndex = sut.guessIndex
            let currentGuessChars = sut.guesses[guessIndex].chars
            
            #expect(currentGuessChars.count == 2)
            #expect(currentGuessChars.contains(where: { $0.symbol == "1" }))
            #expect(currentGuessChars.contains(where: { $0.symbol == "2" }))
        }
        
        @Test("Delete pressed too much times")
        func deletePressedTooMuchTimes() {
            sut.handleKeyPressed(.digit(1))
            sut.handleKeyPressed(.delete)
            sut.handleKeyPressed(.delete)
            
            let guessIndex = sut.guessIndex
            let currentGuessChars = sut.guesses[guessIndex].chars
            
            #expect(currentGuessChars.isEmpty)
        }
        
        @Test("Submit Guess all symbols correct")
        func submitGuessWithAllSymbolsCorrect() {
            let game = Game(equation: "2+5=7", gameSize: .micro)
            sut.setup(with: nil, game: game)
            sut.handleKeyPressed(.digit(2))
            sut.handleKeyPressed(.plus)
            sut.handleKeyPressed(.digit(5))
            sut.handleKeyPressed(.equal)
            sut.handleKeyPressed(.digit(7))
            sut.handleKeyPressed(.enter)
            
            let guess = sut.guesses.first
            let chars = guess?.chars ?? []
            
            #expect(sut.game != nil)
            #expect(guess != nil)
            #expect(guess?.submitted == true)
            #expect(chars.isEmpty == false)
            #expect(chars.allSatisfy({ $0.feedback != nil }))
        }
    }
}
