//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by yukey on 16/5/20.
//  Copyright © 2020 Yukey. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    var description: String {return "\(rank)\(suit)"}
    var rank: Rank
    var suit: Suit
    
    enum Suit: String, CustomStringConvertible {
        case spades = "♠️"
        case hearts = "♥️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all = [Suit.spades,.hearts,.clubs,.diamonds]
        
        var description: String {return rawValue}
    }
        
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
        switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            var allRank = [Rank.ace]
            for pips in 2...10 {
                allRank.append(Rank.numeric(pips))
            }
            allRank += [Rank.face("J"), .face("Q"), .face("K")]
            return allRank
        }
        
        var description: String {
            switch self {
            case .ace:  return "A"
            case .numeric(let pips):  return String(pips)
            case .face(let kind): return kind
            }
        }
    }
}
