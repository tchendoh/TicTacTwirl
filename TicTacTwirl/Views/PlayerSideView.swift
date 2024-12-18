//
//  PlayerSideView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-19.
//

import SwiftUI

struct PlayerSideView: View {
    @Environment(GameViewModel.self) private var gameViewModel: GameViewModel

    var player: Player
    var isReversed: Bool = false

    var body: some View {
        ZStack {
            if gameViewModel.gameStatus == .gameOn {
                HStack {
                    VStack {
                        Spacer()
                        ForEach(0..<3) { _ in
                            Image(systemName: player.team == .xMark ? "xmark" : "circle")
                                .resizable()
                                .foregroundStyle(player.theme == .jinx ? Color("TeamJinxMark") : Color("TeamVioletMark"))
                                .fontWeight(.heavy)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .shadow(color: player.theme == .jinx ? Color("TeamJinxMark") : Color("TeamVioletMark"),
                                        radius: isCurrentPlayerTurn() ? 4 : 0)
                                .opacity(isCurrentPlayerTurn() ? 1.0 : 0.2)

                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 30)
            }

            if gameViewModel.gameStatus == .gameOver {
                VStack {
                    Spacer()
                    if isCurrentPlayerTurn() {
                        Text("VICTORY")
                            .font(.system(size: 100))
                            .fontWidth(.condensed)
                            .fontWeight(.black)
                            .foregroundStyle(player.theme == .jinx ? Color("TeamJinxMark") : Color("TeamVioletMark"))
                            .shadow(radius: 8)

                    } else {
                        Text("SHAME")
                            .font(.system(size: 100))
                            .fontWidth(.condensed)
                            .fontWeight(.black)
                            .foregroundStyle(player.theme == .jinx ? Color("TeamJinxMark") : Color("TeamVioletMark"))
                            .shadow(radius: 8)
                    }
                }
                .padding(.bottom, 80)
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
            PlayerSideView(player: Player(team: .oMark, theme: .violet), isReversed: true)
                .rotationEffect(.degrees(180))
            PlayerSideView(player: Player(team: .xMark, theme: .jinx), isReversed: false)
        }
    }
    .environment(GameViewModel())

}
