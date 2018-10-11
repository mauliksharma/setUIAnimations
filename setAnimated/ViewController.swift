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
        game = Game()
        updateViewFromModel()
    }
    
    var game = Game()
    
    var cardViews = [CardView]()
    
    func updateViewFromModel() {
        cardViews = []
        for index in game.loadedCards.indices {
            let card = game.loadedCards[index]
            let cardView = createCardView(from: card)
            
            if game.matchedCards.contains(card) {
                cardView.isMatched = true
            }
            else if game.selectedCards.contains(card) {
                cardView.isSelected = true
            }
            else {
                cardView.isMatched = false
                cardView.isSelected = false
            }
            cardViews += [cardView]
        }
        playingArea.cardViewsInPlay = cardViews
        setTitle?.textColor = !game.matchedCards.isEmpty ? UIColor.blue : UIColor.white
        scoreLabel?.text = "SCORE: \(game.score)"
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let cardView = recognizer.view as? CardView {
                if let index = cardViews.index(of: cardView) {
                    game.chooseCard(at: index)
                }
                updateViewFromModel()
            }
        }
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
    
}

