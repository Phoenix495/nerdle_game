//
//  CustomGameViewModel.swift
//  NerdleGame
//

import SwiftData
import SwiftUI

@Observable
final class CustomGameViewModel {
    // MARK: - Public properties
    var equationText: String = ""
    var gameSize: GameSize = .classic
    var canCreateGame = false
    var newGame: Game?
    
    // MARK: - Private properties
    private var dbContext: ModelContext?
    
    // MARK: - Public actions
    func setup(with context: ModelContext) {
        self.dbContext = context
    }
    
    func handleEnterEquation(_ newValue: String) {
        let allowedCharacters = "0123456789+-*/="
        let filteredText = newValue.filter { allowedCharacters.contains($0) }
        equationText = String(filteredText.prefix(gameSize.digits))
        validateEquationAndGameSize()
    }
    
    func validateEquationAndGameSize() {
        canCreateGame = isValidEquation(equationText) && equationText.count == gameSize.digits
    }
    
    func createGame() {
        let game = Game(equation: equationText, gameSize: gameSize)
        self.newGame = game
        dbContext?.insert(game)
        saveGame()
    }
    
    // MARK: - Private actions
    private func isValidEquation(_ equation: String) -> Bool {
        // Ensure it contains '=', and both sides can be evaluated.
        let parts = equation.split(separator: "=")
        if parts.count != 2 { return false }
        
        let lhs = parts[0].trimmingCharacters(in: .whitespaces)
        let rhs = parts[1].trimmingCharacters(in: .whitespaces)
        
        // Use NSExpression to validate
        let lhsValue = NSExpression(format: lhs).expressionValue(with: nil, context: nil) as? NSNumber
        let rhsValue = NSExpression(format: rhs).expressionValue(with: nil, context: nil) as? NSNumber
        return lhsValue == rhsValue
    }
    
    private func saveGame() {
        do {
            try dbContext?.save()
        } catch {
            print("save context failed with error:", error)
        }
    }
}
