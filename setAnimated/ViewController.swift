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
    
    @IBOutlet weak var cardsGrid: CardsGridView! {
        didSet {
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(gridSwipeUpHandler(_:)))
            swipe.direction = [.up]
            cardsGrid.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(gridRotateHandler(_:)))
            cardsGrid.addGestureRecognizer(rotate)
            
            updateViewFromModel()
        }
    }
    
    @objc func gridSwipeUpHandler(_ sender: UISwipeGestureRecognizer) {
        game.deal3NewCards()
        updateViewFromModel()
    }
    
    @objc func gridRotateHandler(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            game.shuffleLoadedCards()
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
        cardsGrid.clear()
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
            cardView.alpha = 1
            let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognizer:)))
            cardView.addGestureRecognizer(tap)
        }
        
        setTitle?.textColor = !game.matchedCards.isEmpty ? UIColor.blue : UIColor.white
        scoreLabel?.text = "SCORE: \(game.score)"
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if let cardView = recognizer.view as? CardView {
                if let index = cardsGrid.cardViewsInPlay.index(of: cardView) {
                    game.chooseCard(at: index)
                }
                updateViewFromModel()
                print(cardView)
            }
        }
    }
    
    
}

