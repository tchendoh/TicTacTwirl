//
//  BoardView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-17.
//

import SwiftUI

struct BoardView: View {
    @Environment(GameViewModel.self) private var gameViewModel: GameViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    HStack {
                        SquareView(position: .topLeft)
                        SquareView(position: .topMiddle)
                        SquareView(position: .topRight)
                    }
                    
                    HStack {
                        SquareView(position: .middleLeft)
                        SquareView(position: .middle)
                        SquareView(position: .middleRight)
                    }
                    
                    HStack {
                        SquareView(position: .bottomLeft)
                        SquareView(position: .bottomMiddle)
                        SquareView(position: .bottomRight)
                    }
                }
                .scaleEffect(gameViewModel.gameStatus == .teamPicking ? 0.4 : 1)
                //                .blur(radius: gameViewModel.gameStatus == .teamPicking ? 6 : 0)
                .disabled(gameViewModel.gameStatus != .gameOn)
                Spacer()
                
                
            }
            Spacer()
        }
    }
}

#Preview {
    BoardView()
        .environment(GameViewModel())
}
