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

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ZStack {
            LazyVGrid(columns: columns, spacing: 10) {
                // Boucle pour remplir le conteneur de 30 images identiques
                ForEach(0..<200) { _ in
                    Image(systemName: player.team == .xMark ? "xmark" : "circle")
                        .resizable()
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .opacity(isCurrentPlayerTurn() ? 0.5 : 0.1)
                }
            }
            .padding()
            
//            Image(systemName: player.team == .xMark ? "xmark" : "circle")
//                .resizable()
//                .fontWeight(.black)
//                .foregroundStyle(.white)
//                .aspectRatio(contentMode: .fill)
//                .rotation3DEffect(.degrees(40),
//                                  axis: (x: 1.0, y: 1, z: 0.0),
//                                  anchor: .center,
//                                  anchorZ: 0,
//                                  perspective: 1)
//                .opacity(0.1)
            
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
        (player.team == .xMark && gameViewModel.turn == .xMark) ||
        (player.team == .oMark && gameViewModel.turn == .oMark)
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
