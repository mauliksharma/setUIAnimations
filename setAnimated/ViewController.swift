//
//  ViewController.swift
//  setAnimated
//
//  Created by Maulik Sharma on 11/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game = Game()
    
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var cardsGrid: CardsGridView!
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3NewCards()
        updateViewFromModel()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = Game()
        cardsGrid.clear()
        updateViewFromModel()
        dealButton.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        setLabel.backgroundColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        
        let viewsCount = cardsGrid.cardViewsInPlay.count
        let cardsCount = game.loadedCards.count
        
        if viewsCount < cardsCount {
            cardsGrid.addCardViews(number: cardsCount - viewsCount)
        }
        if viewsCount > cardsCount {
            cardsGrid.removeMatchedCardViews()
        }
        
        for index in game.loadedCards.indices {
            let cardView = cardsGrid.cardViewsInPlay[index]
            let card = game.loadedCards[index]
            cardView.shape = card.shape
            cardView.number = card.number
            cardView.color = card.color
            cardView.shade = card.shade
            cardView.isMatched = game.matchedCards.contains(card)
            cardView.isSelected = game.selectedCards.contains(card)
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognizer:)))
            cardView.addGestureRecognizer(tap)
        }
        
        let cardViewsToDealOut = cardsGrid.cardViewsInPlay.filter { $0.alpha == 0 }
        
        if !cardViewsToDealOut.isEmpty {
            var index = 0
            Timer.scheduledTimer(
                withTimeInterval: 0.2,
                repeats: true,
                block: {timer in
                    let cardView = cardViewsToDealOut[index]
                    let originalFrame = cardView.frame
                    cardView.frame = self.cardsGrid.deckFrame
                    cardView.alpha = 1
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.6,
                        delay: 0,
                        options: [.curveEaseInOut],
                        animations: {cardView.frame = originalFrame
                            if self.game.shuffledDeck.isEmpty {
                                self.dealButton.backgroundColor = UIColor.clear
                            }
                        },
                        completion: { finished in
                            UIView.transition(
                                with: cardView,
                                duration: 0.6,
                                options: [.transitionFlipFromLeft],
                                animations: { cardView.isFaceUp = true },
                                completion: nil)
                    }
                    )
                    index += 1
                    if index == cardViewsToDealOut.count {
                        timer.invalidate()
                    }
            })
        }
        
        scoreLabel.text = "SCORE: \(game.score)"
        
        let matchedCardViews = cardsGrid.cardViewsInPlay.filter { $0.isMatched }
        
        if  !matchedCardViews.isEmpty {
            for cardView in matchedCardViews {
                
                let tempCardView = cardsGrid.duplicateCardView(of: cardView)
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.6,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: { tempCardView.frame = self.cardsGrid.setFrame },
                    completion: { finished in
                        UIView.transition(
                            with: tempCardView,
                            duration: 0.6,
                            options: [.transitionFlipFromRight],
                            animations: { tempCardView.isFaceUp = false },
                            completion: { position in
                                tempCardView.removeFromSuperview()
                                self.setLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
                        })
                })
                cardView.alpha = 0
                cardView.isFaceUp = false
            }
            game.deal3NewCards()
            updateViewFromModel()
        }
        
    }
    
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let cardView = recognizer.view as? CardView {
                if let index = cardsGrid.cardViewsInPlay.index(of: cardView) {
                    game.chooseCard(at: index)
                }
                updateViewFromModel()
            }
        }
    }
    
}
