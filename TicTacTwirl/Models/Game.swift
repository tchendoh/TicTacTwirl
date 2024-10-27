//
//  Game.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-17.
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

struct Player {
    var team: Game.Team = .notPickedYet
    var isReady: Bool = false
    var score: Int = 0
    
    mutating func setAsReady() {
        isReady = true
    }

    mutating func setAsNotReady() {
        isReady = false
    }
}

struct PlayerMove {
    let squarePosition: SquarePosition
    var mark: SquareValue
}

struct Game {
    enum Status {
        case teamPicking
        case gameOn
        case gameOver
    }
    
    enum Team {
        case xMark, oMark
        case notPickedYet
    }

    enum Turn {
        case xMark
        case oMark
        
        func getMark() -> SquareValue {
            switch self {
            case .xMark:
                return .xMark
            case .oMark:
                return .oMark
            }
        }
        
        func getExpiringMark() -> SquareValue {
            switch self {
            case .xMark:
                return .expiringO
            case .oMark:
                return .expiringX
            }
        }
        
        mutating func toggle() {
            switch self {
            case .xMark:
                self = .oMark
            case .oMark:
                self = .xMark
            }
        }
    }

    var board: [SquarePosition: SquareValue] = [:]
    var status: Status = .teamPicking
    var turn: Turn = .xMark
    var currentMarks: [PlayerMove] = []
    var winningLine: [SquarePosition] = []
    var player1: Player = Player()
    var player2: Player = Player()

    init() {
        createBoard()
    }
    
    mutating func createBoard() {
        for position in SquarePosition.allCases {
            board[position] = .empty
        }
    }
    
    mutating func startGame() {
        assignRandomTeamsToPlayers()
        status = .gameOn
    }

    mutating func assignRandomTeamsToPlayers() {
        let shuffledTeams = [Team.xMark, Team.oMark].shuffled()
        
        player1.team = shuffledTeams[0]
        player2.team = shuffledTeams[1]
    }

    func areBothPlayersReady() -> Bool {
        player1.isReady && player2.isReady
    }

    mutating func makeMove(position: SquarePosition) {
        placeNewMark(position: position)
        
        if detectWin() {
            status = .gameOver
        } else {
            expireOldMark()
            turn.toggle()
        }
    }

    mutating private func placeNewMark(position: SquarePosition) {
        board[position] = turn.getMark()
        currentMarks.append(PlayerMove(squarePosition: position, mark: turn.getMark()))

    }

    mutating func expireOldMark() {
        if currentMarks.count > 6 {
            let removedMark = currentMarks.removeFirst()
            board[removedMark.squarePosition] = .empty
        }
        if currentMarks.count > 5 {
            board[currentMarks[0].squarePosition] = turn.getExpiringMark()
        }
    }
    
    mutating func detectWin() -> Bool {
        guard currentMarks.count > 4 else {
            return false
        }
        // Horizontal (3)
        if turn.getMark() == board[.topLeft] &&
            turn.getMark() == board[.topMiddle] &&
            turn.getMark() == board[.topRight] {
            winningLine = [.topLeft, .topMiddle, .topRight]
        } else if turn.getMark() == board[.middleLeft] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.middleRight] {
            winningLine = [.middleLeft, .middle, .middleRight]
        } else if turn.getMark() == board[.bottomLeft] &&
                 turn.getMark() == board[.bottomMiddle] &&
                 turn.getMark() == board[.bottomRight] {
            winningLine = [.bottomLeft, .bottomMiddle, .bottomRight]
        }
        // Vertical (3)
        else if turn.getMark() == board[.topLeft] &&
                 turn.getMark() == board[.middleLeft] &&
                 turn.getMark() == board[.bottomLeft] {
            winningLine = [.topLeft, .middleLeft, .bottomLeft]
        } else if turn.getMark() == board[.topMiddle] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.bottomMiddle] {
            winningLine = [.topMiddle, .middle, .bottomMiddle]
        } else if turn.getMark() == board[.topRight] &&
                 turn.getMark() == board[.middleRight] &&
                 turn.getMark() == board[.bottomRight] {
            winningLine = [.topRight, .middleRight, .bottomRight]
        }
        // Diagonal (2)
        else if turn.getMark() == board[.topLeft] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.bottomRight] {
            winningLine = [.topLeft, .middle, .bottomRight]
        } else if turn.getMark() == board[.topRight] &&
                 turn.getMark() == board[.middle] &&
                 turn.getMark() == board[.bottomLeft] {
            winningLine = [.topRight, .middle, .bottomLeft]
        }
        
        if !winningLine.isEmpty {
            return true
        }
        return false
    }
    
}
