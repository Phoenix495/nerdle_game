//
//  MainViewModel.swift
//  NerdleGame
//
    

import SwiftData
import SwiftUI

@Observable
final class MainViewModel {
    var games: [Game] = []
    
    private var dbContext: ModelContext?
    
    func setup(with context: ModelContext?) {
        self.dbContext = context
        fetchGames()
    }
    
    private func fetchGames() {
        guard let dbContext else { return }
        let fetchDescriptor = FetchDescriptor<Game>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)])
        
        do {
            games = try dbContext.fetch(fetchDescriptor)
        } catch {
            print("games fetching failed with error: ", error)
        }
    }
    
    func getGameToContinue() -> Game? {
        games.first(where: { $0.result == .playing || $0.result == .skip })
    }
    
    func canStartNewGame() -> Bool {
        guard let lastGameDate = games.first?.creationDate else { return true }
        return Calendar.current.isDate(lastGameDate, inSameDayAs: .now) == false
    }
}
