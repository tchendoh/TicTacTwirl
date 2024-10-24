//
//  PlayerSideView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-19.
//

import SwiftUI

struct PlayerSideView: View {
    @Environment(GameViewModel.self) private var gameViewModel: GameViewModel

    var isReversed: Bool = false
    var player: Player

    var body: some View {
        
        ZStack {
            Image(systemName: player.team == .xMark ? "xmark" : "circle")
                .resizable()
                .fontWeight(.black)
                .foregroundStyle(.white)
                .aspectRatio(contentMode: .fill)
                .rotation3DEffect(.degrees(40),
                                  axis: (x: 1.0, y: 1, z: 0.0),
                                  anchor: .center,
                                  anchorZ: 0,
                                  perspective: 1)
                .opacity(0.1)
            
            if gameViewModel.gameStatus == .gameOn {
                if isCurrentPlayerTurn() {
                    ArrowTurnView()
                }
            } else if gameViewModel.gameStatus == .gameOver {
                if isCurrentPlayerTurn() {
                    Text("VICTORY")
                        .font(.system(size: 100))
                        .fontWidth(.condensed)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                    
                } else {
                    Text("SHAME")
                        .font(.system(size: 100))
                        .fontWidth(.condensed)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                }
            }
        }
    }    
    func isCurrentPlayerTurn() -> Bool {
        if (player.team == .xMark && gameViewModel.turn == .xMark) ||
            (player.team == .oMark && gameViewModel.turn == .oMark) {
            return true
        } else {
            return false
        }
        
    }

}

#Preview {
    ZStack {
        Color.blue
        VStack {
            PlayerSideView(isReversed: true, player: Player(team: .oMark))
                .rotationEffect(.degrees(180))
            PlayerSideView(isReversed: false, player: Player(team: .xMark))
        }
    }
    .environment(GameViewModel())

}
