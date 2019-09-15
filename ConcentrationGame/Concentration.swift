//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 R2. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCard: Int) {
        var tempCards = [Card]()
        for _ in 1...numberOfPairsOfCard {
            let card = Card()
            tempCards += [card, card]
        }
        for _ in tempCards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(tempCards.count)))
            cards.append(tempCards.remove(at: randomIndex))
        }
    }
}
