//
//  Square.swift
//  TicTacTwirl
//
//  Created by Eric Chandonnet on 2024-12-05.
//

import Foundation

enum SquarePosition: CaseIterable {
    case topLeft
    case topMiddle
    case topRight
    case middleLeft
    case middle
    case middleRight
    case bottomLeft
    case bottomMiddle
    case bottomRight
}

enum SquareMark {
    case xMark
    case oMark
    case expiringX
    case expiringO
    case empty
}

struct SquareValue {
    var mark: SquareMark = .empty
    var theme: Player.Theme?
}
