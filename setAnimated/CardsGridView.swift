//
//  CardsGridView.swift
//  setGraphics
//
//  Created by Maulik Sharma on 04/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class CardsGridView: UIView {
    
    var cardViewsInPlay: [CardView] = [CardView]()
    { didSet { setNeedsDisplay(); layoutIfNeeded() } }
    
    var grid = Grid(layout: .aspectRatio(5/8))
    
    var deckExhausted = false
    
    var deckFrame = CGRect()
    var setFrame = CGRect()
    
    func addCardViews(number: Int) {
        var newCardViews = [CardView]()
        for _ in 1...number {
            let cardView = CardView()
            cardView.alpha = 0
            addSubview(cardView)
            newCardViews.append(cardView)
        }
        cardViewsInPlay += newCardViews
    }
    
    func removeMatchedCardViews() {
        let matchedCardViews = cardViewsInPlay.filter { $0.isMatched }
        for cardView in matchedCardViews {
            cardView.removeFromSuperview()
            cardViewsInPlay.remove(at: cardViewsInPlay.index(of: cardView)!)
        }
    }
    
    func duplicateCardView(of cardView: CardView) -> CardView {
        let newCardView = CardView()
        newCardView.shape = cardView.shape
        newCardView.number = cardView.number
        newCardView.color = cardView.color
        newCardView.shade = cardView.shade
        newCardView.isFaceUp = cardView.isFaceUp
        newCardView.frame = cardView.frame
        addSubview(newCardView)
        return newCardView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        grid.cellCount = cardViewsInPlay.count
        configureCardSubViews()
        deckFrame = CGRect(x: bounds.minX, y: bounds.maxY + 10, width: 50, height: 80)
        setFrame = CGRect(x: bounds.maxX - 50, y: bounds.maxY + 10, width: 50, height: 80)
    }
    
    func configureCardSubViews() {
        for index in cardViewsInPlay.indices {
            let cardView = cardViewsInPlay[index]
            guard cardView.alpha == 1 else { cardView.frame = grid[index]!.zoom(by: 0.9); return }
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut],
                animations: { cardView.frame = self.grid[index]!.zoom(by: 0.9) },
                completion: nil)
        }
    }
    
    func clear() {
        cardViewsInPlay.removeAll()
        removeAllSubViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
    }
}

extension UIView {
    func removeAllSubViews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

