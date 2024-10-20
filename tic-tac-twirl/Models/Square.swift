//
//  Square.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-17.
//

import Foundation

enum SquareValue {
    case x
    case o
    case expiringX
    case expiringO
    case empty
}

struct Square {
    let position: SquarePosition
    var value: SquareValue
    var age: Int
}
