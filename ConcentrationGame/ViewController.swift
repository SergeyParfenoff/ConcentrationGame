//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Сергей on 11/09/2019.
//  Copyright © 2019 R2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var game = Concentration(numberOfPairsOfCard)
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Счет: \(flipCount)"
        }
    }
    
    
    @IBOutlet var cardViews: [CardView]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction private func touchNewGameButton() {
        emojiChoices = getEmojiChoices()
        flipCount = 0
        game = Concentration(numberOfPairsOfCard)
        updateViewFromModel()
    }
    
    var numberOfPairsOfCard: Int {
        return cardViews.count / 2
    }
    
    private func updateViewFromModel(completion: Bool = false) -> Void {
        for index in cardViews.indices {
            let cardView = cardViews[index]
            let card = game.cards[index]
            if cardView.isFaceUp != card.isFaceUp {
                let flip: UIView.AnimationOptions = (card.isFaceUp ? .transitionFlipFromRight : .transitionFlipFromLeft)
                UIView.transition(with: cardView,
                                  duration: 0.6,
                                  options: [flip],
                                  animations: { cardView.isFaceUp = card.isFaceUp })}
        }
    }
    
    private lazy var emojiChoices = getEmojiChoices()
    private var emoji = [Int : String]()
    
    private func getEmojiChoices() -> [String] {
        let emojiString = "😈👹👽💀🤡👻🙀💩🤖🎃🧙‍♀️"
        var emojiChoices = emojiString.map( { String($0) } )
        emojiChoices.shuffle()
        return emojiChoices
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count - 1)
        }
        return emoji[card.identifier] ?? ""
    }
    
    override func viewDidLoad() {
        
        for cardViewIndex in cardViews.indices {
            let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
            let cardView = cardViews[cardViewIndex]
            let card = game.cards[cardViewIndex]
            cardView.emoji = emoji(for: card)
            cardView.addGestureRecognizer(tapRecogniser)
        }
        
        updateViewFromModel()
        
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let cardView = recognizer.view as? CardView {
                flipCount += 1
                game.chooseCard(at: cardViews.firstIndex(of: cardView)!)
                updateViewFromModel()
            }
        }
    }
    
    
}

