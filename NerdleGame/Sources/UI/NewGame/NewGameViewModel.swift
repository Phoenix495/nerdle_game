//
//  NewGameViewModel.swift
//  NerdleGame
//
    

import SwiftData
import SwiftUI

@Observable
final class NewGameViewModel {
    private(set) var game: Game?
    private var dbContext: ModelContext?
    
    func setup(with context: ModelContext) {
        self.dbContext = context
    }
    
    func createNewGame(with size: GameSize) {
        let equation = generateRandomEquation(with: size.digits)
        let newGame = Game(equation: equation, gameSize: size)
        game = newGame
        dbContext?.insert(newGame)
        
        saveGame()
    }
    
    func generateRandomEquation(with length: Int) -> String {        
        var equation = ""

        while equation.count < length {
            let numDigitsLeft = Int.random(in: 1...3)
            let left = String(Int.random(in: 0...9), radix: 10, uppercase: false).padding(toLength: numDigitsLeft, withPad: "0", startingAt: 0)
            let numDigitsRight = Int.random(in: 1...3)
            let right = String(Int.random(in: 0...9), radix: 10, uppercase: false).padding(toLength: numDigitsRight, withPad: "0", startingAt: 0)
            let operatorSymbol = ["+", "-", "*", "/"].randomElement()!
            
            equation = "\(left)\(operatorSymbol)\(right)"
            let result = evaluateExpression(equation)
            
            if equation.count + String(result).count + 1 == length {
                equation += "=\(result)"
                break
            } else if equation.count + String(result).count + 1 > length {
                equation = ""
            }
        }
        
        return equation
    }
    
    private func evaluateExpression(_ expression: String) -> Int {
        let exp = NSExpression(format: expression)
        return exp.expressionValue(with: nil, context: nil) as! Int
    }
    
    private func saveGame() {
        do {
            try dbContext?.save()
        } catch {
            print("save context failed with error:", error)
        }
    }
}
