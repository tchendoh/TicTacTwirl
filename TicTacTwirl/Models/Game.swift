//
//  Game.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-17.
//

import Foundation

struct Game {
    enum Status {
        case teamPicking
        case gameOn
        case gameOver
    }
    
    enum Team {
        case xMark
        case oMark
        case notPickedYet
    }
    
    enum Turn {
        case xMark
        case oMark
                
        func getMark() -> SquareMark {
            switch self {
            case .xMark:
                return .xMark
            case .oMark:
                return .oMark
            }
        }

        func getTeam() -> Team {
            switch self {
            case .xMark:
                return .xMark
            case .oMark:
                return .oMark
            }
        }

        func getExpiringMark() -> SquareMark {
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
    var assignedTeamsNormal: Bool = true
    var currentMarks: [PlayerMove] = []
    var winningLine: [SquarePosition] = []
    var player1: Player = Player(theme: .violet)
    var player2: Player = Player(theme: .jinx)

    init() {
        createBoard()
    }
    
    mutating func createBoard() {
        for position in SquarePosition.allCases {
            board[position] = SquareValue()
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
    
    func currentPlayer() -> Player {
        if turn.getTeam() == player1.team {
            return player1
        } else {
            return player2
        }
    }

    func areBothPlayersReady() -> Bool {
        player1.isReady && player2.isReady
    }

    func areBothPlayersGettingReady() -> Bool {
        player1.isGettingReady && player2.isGettingReady
    }

    mutating func makeMove(position: SquarePosition, player: Player) {
        placeNewMark(position: position, player: player)
        
        if detectWin() {
            status = .gameOver
        } else {
            expireOldMark()
            turn.toggle()
        }
    }

    mutating private func placeNewMark(position: SquarePosition, player: Player) {
        board[position] = SquareValue(mark: turn.getMark(), theme: player.theme)
        currentMarks.append(PlayerMove(squarePosition: position, player: player))
    }

    mutating func expireOldMark() {
        if currentMarks.count > 6 {
            let removedMark = currentMarks.removeFirst()
            board[removedMark.squarePosition] = SquareValue()
        }
        if currentMarks.count > 5 {
            board[currentMarks[0].squarePosition]?.mark = turn.getExpiringMark()
        }
    }
    
    mutating func detectWin() -> Bool {
        guard currentMarks.count > 4 else {
            return false
        }
        // Horizontal (3)
        if turn.getMark() == board[.topLeft]?.mark &&
            turn.getMark() == board[.topMiddle]?.mark &&
            turn.getMark() == board[.topRight]?.mark {
            winningLine = [.topLeft, .topMiddle, .topRight]
        } else if turn.getMark() == board[.middleLeft]?.mark &&
                 turn.getMark() == board[.middle]?.mark &&
                 turn.getMark() == board[.middleRight]?.mark {
            winningLine = [.middleLeft, .middle, .middleRight]
        } else if turn.getMark() == board[.bottomLeft]?.mark &&
                 turn.getMark() == board[.bottomMiddle]?.mark &&
                 turn.getMark() == board[.bottomRight]?.mark {
            winningLine = [.bottomLeft, .bottomMiddle, .bottomRight]
        }
        // Vertical (3)
        else if turn.getMark() == board[.topLeft]?.mark &&
                 turn.getMark() == board[.middleLeft]?.mark &&
                 turn.getMark() == board[.bottomLeft]?.mark {
            winningLine = [.topLeft, .middleLeft, .bottomLeft]
        } else if turn.getMark() == board[.topMiddle]?.mark &&
                 turn.getMark() == board[.middle]?.mark &&
                 turn.getMark() == board[.bottomMiddle]?.mark {
            winningLine = [.topMiddle, .middle, .bottomMiddle]
        } else if turn.getMark() == board[.topRight]?.mark &&
                 turn.getMark() == board[.middleRight]?.mark &&
                 turn.getMark() == board[.bottomRight]?.mark {
            winningLine = [.topRight, .middleRight, .bottomRight]
        }
        // Diagonal (2)
        else if turn.getMark() == board[.topLeft]?.mark &&
                 turn.getMark() == board[.middle]?.mark &&
                 turn.getMark() == board[.bottomRight]?.mark {
            winningLine = [.topLeft, .middle, .bottomRight]
        } else if turn.getMark() == board[.topRight]?.mark &&
                 turn.getMark() == board[.middle]?.mark &&
                 turn.getMark() == board[.bottomLeft]?.mark {
            winningLine = [.topRight, .middle, .bottomLeft]
        }
        
        if !winningLine.isEmpty {
            return true
        }
        return false
    }
    
}
