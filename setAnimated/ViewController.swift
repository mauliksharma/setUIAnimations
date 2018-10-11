//
//  ViewController.swift
//  setAnimated
//
//  Created by Maulik Sharma on 11/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playingArea: CardsGridView! {
        didSet {
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var setTitle: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var dealButton: UIButton!
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.deal3NewCards()
        updateViewFromModel()
    }
    
    @IBAction func startAgain(_ sender: UIButton) {
        playingArea.cardViewsInPlay.removeAll()
        game = Game()
        updateViewFromModel()
    }
    
    var game = Game()
    
    func updateViewFromModel() {
        var newCardViews = [CardView]()
        if playingArea.cardViewsInPlay.count < game.loadedCards.count {
            for index in playingArea.cardViewsInPlay.count...(game.loadedCards.count - 1) {
                newCardViews.append(createCardView(from: game.loadedCards[index]))
            }
            playingArea.addCardViewsInPlay(newCardViews)
        }
        
        for index in playingArea.cardViewsInPlay.indices {
            let cardView = playingArea.cardViewsInPlay[index]
            let card = game.loadedCards[index]
            if game.matchedCards.contains(card) {
                cardView.isMatched = true
            }
            else if game.selectedCards.contains(card) {
                cardView.isSelected = true
            }
            else {
                if cardView.isMatched { cardView.isMatched = false }
                if cardView.isSelected { cardView.isSelected = false }
            }
        }
        
        setTitle?.textColor = !game.matchedCards.isEmpty ? UIColor.blue : UIColor.white
        scoreLabel?.text = "SCORE: \(game.score)"
    }
    
    
    func createCardView(from card: Card) -> CardView {
        let cardView = CardView()
        cardView.shape = card.shape
        cardView.color = card.color
        cardView.number = card.number
        cardView.shade = card.shade
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognizer:)))
        cardView.addGestureRecognizer(tap)
        return cardView
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let cardView = recognizer.view as? CardView {
                if let index = playingArea.cardViewsInPlay.index(of: cardView) {
                    game.chooseCard(at: index)
                }
                updateViewFromModel()
            }
        }
    }
    
    
}

