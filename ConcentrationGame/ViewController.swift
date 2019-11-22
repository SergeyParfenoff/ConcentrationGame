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
    
    private func updateScore() {
        flipCountLabel.text = "Счет: \(game.score)"
    }
    
    @IBOutlet var aspectRatioConstrain: NSLayoutConstraint!
    @IBOutlet var bottomConstrain: NSLayoutConstraint!
    @IBOutlet var cardViews: [CardView]!
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction private func touchNewGameButton() {
        emojiChoices = getEmojiChoices()
        game = Concentration(numberOfPairsOfCard)
        updateViewFromModel()
        updateScore()
    }
    
    var numberOfPairsOfCard: Int {
        return cardViews.count / 2
    }
    
    private var isAnimating = false
    
    private func updateViewFromModel() {
        
        var matchingCardViews: [CardView]? {
            get {
                if let indexesOfMatchingPair = game.indexesOfMatchingPair {
                    var matchingCardViews: [CardView] = []
                    indexesOfMatchingPair.forEach {
                        matchingCardViews.append( cardViews[$0] )
                    }
                    return matchingCardViews
                } else {
                    return nil
                }
            }
        }
        
        for index in cardViews.indices {
            let cardView = cardViews[index]
            let card = game.cards[index]
            
            cardView.emoji = emoji(for: card)
            if !card.isMatched, cardView.alpha != 1 {
              cardView.alpha = 1
            }
            
            if cardView.isFaceUp != card.isFaceUp {
                let flip: UIView.AnimationOptions = card.isFaceUp ? .transitionFlipFromRight : .transitionFlipFromLeft
                UIView.transition(with: cardView,
                                  duration: 0.6,
                                  options: [flip],
                                  animations: { cardView.isFaceUp = card.isFaceUp })}
            
        }
        
        if matchingCardViews != nil {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0.6,
                options: [],
                animations: { self.isAnimating = true
                    matchingCardViews?.forEach { $0.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5) }
            },
                completion: { position in
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.8,
                        delay: 0,
                        options: [],
                        animations: {
                            matchingCardViews?.forEach {
                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                $0.alpha = 0
                            }
                    },
                        completion: { position in
                            self.isAnimating = false
                            matchingCardViews?.forEach {
                                $0.transform = .identity
                            }
                    })
            })
        }
    }
    
    private lazy var emojiChoices = getEmojiChoices()
    private var emoji = [Int : String]()
    
    private func getEmojiChoices() -> [String] {
        let emojiString = "😈👹👽💀🤡👻🙀💩🤖🎃🐞🐭🐷👁"
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
            cardView.addGestureRecognizer(tapRecogniser)
        }
        
        updateViewFromModel()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let isHorizontal = view.bounds.width > view.bounds.height
        aspectRatioConstrain.isActive = !isHorizontal
        bottomConstrain.isActive = isHorizontal
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let cardView = recognizer.view as? CardView, !isAnimating {
                game.chooseCard(at: cardViews.firstIndex(of: cardView)!)
                updateScore()
                updateViewFromModel()
            }
        }
    }
    
}

