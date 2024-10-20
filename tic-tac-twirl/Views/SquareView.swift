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
        if let value = gameViewModel.game.board[position] {
            ZStack {
                RoundedRectangle(cornerRadius: squareSize / 5)
                    .foregroundStyle(isInWinningLine() ? Color("SquareWinBackground").gradient : Color("SquareBackground").gradient)
                    .onTapGesture {
                        if value == .empty {
                            gameViewModel.makeMove(at: position)
                        }
                    }
                
                switch value {
                case .x:
                    Image(systemName: "xmark")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                case .o:
                    Image(systemName: "circle")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                case .expiringX:
                    Image(systemName: "xmark")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                        .opacity(0.2)
                case .expiringO:
                    Image(systemName: "circle")
                        .font(.system(size: squareSize/2))
                        .fontWeight(.black)
                        .opacity(0.2)
                case .empty:
                    Spacer()
                }
                
                
            }
            .frame(width: squareSize, height: squareSize)
            .wiggling(isWiggling: $isWiggling, rotationAmount: 3, bounceAmount: 2)
            .onChange(of: value) { oldValue, newValue in
                if value == .expiringO || value == .expiringX {
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
}

#Preview {
    ZStack {
        Color.blue
        SquareView(position: .topLeft)
            .environment(GameViewModel())
        
    }
}
