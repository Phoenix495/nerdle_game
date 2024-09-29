//
//  InputKeyType.swift
//  NerdleGame
//
    
import SwiftUI

enum InputKeyType: Equatable {
    case digit(Int)
    case plus
    case minus
    case multiply
    case divide
    case equal
    case enter
    case delete
    
    var symbol: String {
        switch self {
        case .digit(let num): "\(num)"
        case .plus: "+"
        case .minus: "-"
        case .multiply: "*"
        case .divide: "/"
        case .equal: "="
        case .enter: "Enter"
        case .delete: "Delete"
        }
    }
    
    var keyEquivalent: KeyEquivalent {
        switch self {
        case .digit(let int):
            switch int {
            case 0: KeyEquivalent("0")
            case 1: KeyEquivalent("1")
            case 2: KeyEquivalent("2")
            case 3: KeyEquivalent("3")
            case 4: KeyEquivalent("4")
            case 5: KeyEquivalent("5")
            case 6: KeyEquivalent("6")
            case 7: KeyEquivalent("7")
            case 8: KeyEquivalent("8")
            case 9: KeyEquivalent("9")
            default: KeyEquivalent(" ")
            }
        case .plus:
            KeyEquivalent("+")
        case .minus:
            KeyEquivalent("-")
        case .multiply:
            KeyEquivalent("*")
        case .divide:
            KeyEquivalent("/")
        case .equal:
            KeyEquivalent("=")
        case .enter:
            KeyEquivalent.return
        case .delete:
            KeyEquivalent.delete
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (let .digit(digitLhs), let .digit(digitRhs)):
            digitLhs == digitRhs
        case (.plus, .plus),
            (.minus, .minus),
            (.multiply, .multiply),
            (.divide, .divide),
            (.equal, .equal),
            (.enter, .enter),
            (.delete, .delete):
            true
        default:
            false
        }
    }
}

