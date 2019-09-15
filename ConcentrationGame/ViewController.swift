//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Сергей on 11/09/2019.
//  Copyright © 2019 R2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCard: (cardButtons.count + 1) / 2)
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Счет: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchButton(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("выбранная карта не в массиве cardButtons")
        }
    }
    
    @IBAction func touchNewGameButton() {
        emojiChoices = getEmojiChoices()
        flipCount = 0
        game = Concentration(numberOfPairsOfCard: (cardButtons.count + 1) / 2)
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
            } else {
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6117921472, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                button.setTitle("", for: UIControl.State.normal)
            }
        }
    }
   
    lazy var emojiChoices = getEmojiChoices()
    var emoji = [Int : String]()
    
    func getEmojiChoices() -> [String] {
        return ["😈", "👹", "👽", "💀", "🤡", "👻", "🙀", "💩", "🤖", "🎃", "🧙‍♀️"]
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
}

