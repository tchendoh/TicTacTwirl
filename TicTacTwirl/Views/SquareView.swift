//
//  SquareView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-17.
//

import SwiftUI

struct SquareView: View {
    @Environment(GameViewModel.self) private var gameViewModel: GameViewModel
    let position: SquarePosition
    var squareSize: CGFloat = 90
    
    @State private var isWiggling = false
    
    var body: some View {
        if let squareValue = gameViewModel.game.board[position] {
            ZStack {
                RoundedRectangle(cornerRadius: squareSize / 5)
                    .foregroundStyle(getSquareColor(squareValue: squareValue))
                    .onTapGesture {
                        if squareValue.mark == .empty {
                            gameViewModel.makeMove(position: position, player: gameViewModel.game.currentPlayer())
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: squareSize / 5)
                            .stroke(Color("SquareBorder"), lineWidth: 3)
                    )
                    .shadow(radius: 4)
                
                switch squareValue.mark {
                case .xMark:
                    Image(systemName: "xmark")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                        .foregroundStyle(getMarkColor(squareValue: squareValue))
                case .oMark:
                    Image(systemName: "circle")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                        .foregroundStyle(getMarkColor(squareValue: squareValue))
                case .expiringX:
                    Image(systemName: "xmark")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                        .foregroundStyle(getMarkColor(squareValue: squareValue))
                        .opacity(0.4)
                case .expiringO:
                    Image(systemName: "circle")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                        .foregroundStyle(getMarkColor(squareValue: squareValue))
                        .opacity(0.4)
                case .empty:
                    Spacer()
                }
            }
            .frame(width: squareSize, height: squareSize)
            .wiggling(isWiggling: $isWiggling, rotationAmount: 3, bounceAmount: 2)
            .onChange(of: squareValue.mark) { _, _ in
                if squareValue.mark == .expiringO || squareValue.mark == .expiringX {
                    isWiggling = true
                } else {
                    isWiggling = false
                }
            }
        }
        
    }
    
    func isInWinningLine() -> Bool {
        gameViewModel.winningLine.contains(position)
    }
    
    func getSquareColor(squareValue: SquareValue) -> Color {
        if squareValue.mark == .empty {
            return Color("SquareBackground")
        } else if isInWinningLine() {
            return Color("SquareWinBackground")
        } else {
            if let theme = squareValue.theme {
                switch theme {
                case .violet:
                    return Color("TeamVioletSquare")
                case .jinx:
                    return Color("TeamJinxSquare")
                }
            }
        }
        return .black
    }
    
    func getMarkColor(squareValue: SquareValue) -> Color {
        if let theme = squareValue.theme {
            switch theme {
            case .violet:
                return Color("TeamVioletMark")
            case .jinx:
                return Color("TeamJinxMark")
            }
        }
        return .black
    }
}

#Preview {
    ZStack {
        Color.blue
        SquareView(position: .topLeft)
            .environment(GameViewModel())
        
    }
}
