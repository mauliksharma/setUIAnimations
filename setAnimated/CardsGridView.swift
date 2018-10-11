//
//  CardsGridView.swift
//  setGraphics
//
//  Created by Maulik Sharma on 04/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class CardsGridView: UIView {
    
    var cardViewsInPlay: [CardView] = [CardView]() { didSet { setNeedsLayout() } }
    
    var grid = Grid(layout: .aspectRatio(5/8))
    
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
    
    func removeCardViews(number: Int) {
        for _ in 1...number {
            subviews.last?.removeFromSuperview()
        }
        cardViewsInPlay.removeLast(number)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = bounds
        grid.cellCount = cardViewsInPlay.count
        configureCardSubViews()
    }
    
    func configureCardSubViews() {
        for index in cardViewsInPlay.indices {
            cardViewsInPlay[index].frame = grid[index]!.zoom(by: 0.9)
        }
    }
    
    func clear() {
        cardViewsInPlay.removeAll()
        removeAllSubViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
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

