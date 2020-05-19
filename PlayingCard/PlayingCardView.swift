//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by yukey on 17/5/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import UIKit

//setNeedsDisplay() call draw function？？？？？
//setNeedsLayout() call layoutSubviews？？？？？
class PlayingCardView: UIView {
    var rank: Int = 11 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    var suit: String = "♥️" {didSet {setNeedsDisplay(); setNeedsLayout()}}
    var isFaceUp: Bool = true {didSet {setNeedsDisplay(); setNeedsLayout()}}
    
//1.choose font style
//2. font can be scale up and  down
//3. declare text style(center)
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString  {
        var font =  UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string:string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
//cornerFontSize: size of 5 and heart
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = creatCornerLabel()
    private lazy var lowerRightCornerLabel = creatCornerLabel()
    
//create a UIlabel
//numberOfLines means: it can have multiple line in the label
//addSubview:  put UI label into PlayingCardView subclass
    private func creatCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }
    
//label.frame.size = CGSize.zero:  init  label size
    private func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
//why need to call superlayout???????????
// transform的位置？？？？？？？？？
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
        
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if let faceCardImage = UIImage(named: rankString+"♥") {
            faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundSize))
        }
    }

}

extension PlayingCardView {
    private struct SizeRatio {
//font/bound height
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
//弧的角度/边界高度
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06

        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundSize: CGFloat = 0.75
    }
//弧的半径
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
//圆心到最大边界的距离
    private var cornerOffset: CGFloat {
        return cornerRadius *  SizeRatio.cornerOffsetToCornerRadius
    }
//5 and heart size
    private var cornerFontSize: CGFloat {
        return bounds.size.height *  SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y:minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: minX, y:minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin:origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}



