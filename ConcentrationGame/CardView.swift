//
//  CardView.swift
//  ConcentrationGame
//
//  Created by Сергей on 03/10/2019.
//  Copyright © 2019 R2. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var emoji: String = ""
    var isFaceUp: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: rect.width * 0.1)
        roundedRect.addClip()
        if isFaceUp {
            UIColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).setFill()
            roundedRect.fill()
            let label = UILabel()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let font = UIFont(name: UIFont.preferredFont(forTextStyle: .body).fontName, size: rect.width/1.5)
            label.attributedText = NSAttributedString(string: emoji, attributes: [.paragraphStyle: paragraphStyle, .font: font])
            label.drawText(in: rect)
        } else {
            UIColor(#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)).setFill()
            roundedRect.fill()
        }
                
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor.black
    }
    
}
