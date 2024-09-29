//
//  FeedbackType.swift
//  NerdleGame
//
    

import SwiftUI

enum FeedbackType: Int, Codable, CaseIterable {
    case correct
    case wrongPosition
    case incorrect
}

// MARK: - Feedback color
extension FeedbackType {
    var color: Color {
        switch self {
        case .correct: .green
        case .wrongPosition: .purple
        case .incorrect: .black
        }
    }
}
