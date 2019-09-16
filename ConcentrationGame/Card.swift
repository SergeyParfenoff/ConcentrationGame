//
//  Card.swift
//  ConcentrationGame
//
//  Created by Сергей on 15/09/2019.
//  Copyright © 2019 R2. All rights reserved.
//

import Foundation

struct Card {
    
    var testVar = 2
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getNewIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getNewIdentifier()
    }
}

