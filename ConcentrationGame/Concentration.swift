//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 R2. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var score = 0
    private(set) var cards = [Card]()
    private(set) var indexesOfMatchingPair: [Int]?
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
        
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    indexesOfMatchingPair = [index, matchIndex]
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    indexesOfMatchingPair = nil
                    if cards[index].hasBeenOpened { score -= 1 }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
                indexesOfMatchingPair = nil
            }
            cards[index].hasBeenOpened = true
        }
    }
    
    init(_ numberOfPairsOfCard: Int) {
        for _ in 1...numberOfPairsOfCard {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

