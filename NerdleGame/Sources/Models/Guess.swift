//
//  Guess.swift
//  NerdleGame
//
    
import Foundation
import SwiftData

@Model
class Guess {
    @Attribute(.unique) var id: UUID
    var chars: [GuessChar]
    var submitted: Bool
    
    var charsSorted: [GuessChar] {
        chars.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
    }
    
    init(id: UUID = .init(), chars: [GuessChar] = [], submitted: Bool = false) {
        self.id = id
        self.chars = chars
        self.submitted = submitted
    }
}

@Model
class GuessChar {
    @Attribute(.unique) var id: UUID
    var symbol: String
    var feedback: FeedbackType?
    var date: Date
    
    init(id: UUID = .init(), symbol: String, feedback: FeedbackType? = nil, date: Date = .now) {
        self.id = id
        self.symbol = symbol
        self.feedback = feedback
        self.date = date
    }
}
