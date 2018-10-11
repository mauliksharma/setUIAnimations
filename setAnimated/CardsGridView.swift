//
//  CardsGridView.swift
//  setGraphics
//
//  Created by Maulik Sharma on 04/10/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

class CardsGridView: UIView {
    
    var cardViewsInPlay = [CardView]() { didSet { setNeedsLayout() } }
    
    var cardsGrid = Grid(layout: .aspectRatio(5/8))
    
    func configureCardSubViews(_ cardSubViews: [CardView]) {
        for index in cardSubViews.indices {
            cardSubViews[index].frame = cardsGrid[index]!.zoom(by: 0.9)
        }
    }
    
    func addCardViewsInPlay(_ cardViews: [CardView]) {
        cardViews.forEach {
            addSubview($0)
            cardViewsInPlay.append($0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardsGrid.frame = bounds
        cardsGrid.cellCount = subviews.count
        configureCardSubViews(cardViewsInPlay)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
}

extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}
