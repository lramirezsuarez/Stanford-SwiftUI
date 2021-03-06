//
//  CardItemViewModel.swift
//  Memorize
//
//  Created by Luis Alejandro Ramirez Suarez on 7/07/22.
//

import SwiftUI

final class CardItemViewModel: Identifiable, ObservableObject {
    var item: CardItem
    @Published var faceUp: Bool {
        didSet {
            if faceUp {
                startUsingBonusTime()
            } else {
                stopUsingBonusTime()
            }
        }
    }
    @Published var matched: Bool {
        didSet {
            stopUsingBonusTime()
        }
    }
    
    init(item: CardItem,
         faceUp: Bool = false,
         matched: Bool = false) {
        self.item = item
        self.faceUp = faceUp
        self.matched = matched
    }
    
    func cardTapped() {
        faceUp.toggle()
    }
    
    // MARK: - Bonus Time
    
    // this could give matching bonus points
    // if the user matches the card
    // before a certain amount of time passes during which the card is face up
    
    // can be zero which means "no bonus available" for this card
    var bonusTimeLimit: TimeInterval = 6
    
    // how long this card has ever been face up
    private var faceUpTime: TimeInterval {
        if let lastFaceUpDate = self.lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    // the last time this card was turned face up (and is still face up)
    var lastFaceUpDate: Date?
    // the accumulated time this card has been face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0
    
    // how much time left before the bonus opportunity runs out
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    // percentage of the bonus time remaining
    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    // whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
        matched && bonusTimeRemaining > 0
    }
    // whether we are currently face up, unmatched and have not yet used up the bonus window
    var isConsumingBonusTime: Bool {
        faceUp && !matched && bonusTimeRemaining > 0
    }
    
    // called when the card transitions to face up state
    private func startUsingBonusTime() {
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    // called when the card goes back face down (or gets matched)
    private func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
    }
}
