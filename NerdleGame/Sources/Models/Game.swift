//
//  Game.swift
//  NerdleGame
//
    
import SwiftUI
import SwiftData

@Model
class Game {
    @Attribute(.unique) var id: UUID
    var equation: String
    var gameSize: GameSize
    var guesses: [Guess]
    var result: GameResult
    var creationDate: Date
    
    init(id: UUID = .init(), equation: String, gameSize: GameSize, guesses: [Guess] = [], result: GameResult = .playing) {
        self.id = id
        self.equation = equation
        self.gameSize = gameSize
        self.guesses = guesses
        self.result = result
        self.creationDate = .now
    }
    
    static func empty() -> Game {
        .init(equation: "", gameSize: .classic)
    }
}

enum GameSize: Int, Codable, CaseIterable {
    case classic
    case mini
    case micro
    
    var digits: Int {
        switch self {
        case .classic: 8
        case .mini: 6
        case .micro: 5
        }
    }
    
    var guesses: Int { 6 }
    
    var title: String {
        switch self {
        case .classic: "Classic (\(digits)x\(guesses))"
        case .mini: "Mini (\(digits)x\(guesses))"
        case .micro: "Micro (\(digits)x\(guesses))"
        }
    }
}

enum GameResult: Int, Codable {
    case playing
    case skip
    case loose
    case win
    
    var title: String {
        switch self {
        case .playing:
            ""
        case .skip:
            "Skipped"
        case .loose:
            "Loose"
        case .win:
            "Won"
        }
    }
    
    var color: Color {
        switch self {
        case .playing: .gray
        case .skip: .gray
        case .loose: .red
        case .win: .green
        }
    }
}
