//
//  SideView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-19.
//

import SwiftUI

struct SideView: View {
    @Environment(GameViewModel.self) private var gameViewModel: GameViewModel
    var isReversed: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                ZStack {
                    if isReversed {
                        Color("TeamVioletBackground")
                    } else {
                        Color("TeamJinxBackground")
                    }
                    
                    VStack {
                        if gameViewModel.gameStatus == .teamPicking {
                            SpinningCircleView(isReversed: isReversed)
                        } else {
                            PlayerSideView(player: isReversed ? gameViewModel.player1 : gameViewModel.player2, isReversed: isReversed)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    VStack(spacing: 0) {
        SideView(isReversed: true)
            .rotationEffect(.degrees(180))
        SideView()
    }
    .environment(GameViewModel())
}
