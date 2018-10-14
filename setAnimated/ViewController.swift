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
    
    @IBOutlet weak var setTitle: UILabel!
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var cardsGrid: CardsGridView!
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3NewCards()
        updateViewFromModel()
    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        game = Game()
        cardsGrid.clear()
        updateViewFromModel()
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
            cardsGrid.removeCardViews(number: viewsCount - cardsCount)
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
                        delay: 0.3,
                        options: [.curveEaseInOut],
                        animations: {cardView.frame = originalFrame},
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
        
        if !game.matchedCards.isEmpty {
            for card in game.matchedCards {
                if let index = game.loadedCards.index(of: card) {
                    let cardView = cardsGrid.cardViewsInPlay[index]
                    if cardView.alpha == 1 {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.4,
                            delay: 0,
                            options: [],
                            animations: {cardView.alpha = 0},
                            completion: nil)
                    }
                }
            }
        }
        
        dealButton.backgroundColor = !game.shuffledDeck.isEmpty ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1) : UIColor.clear
        setTitle.textColor = !game.matchedCards.isEmpty ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1) : UIColor.white
        scoreLabel.text = "SCORE: \(game.score)"
        
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
