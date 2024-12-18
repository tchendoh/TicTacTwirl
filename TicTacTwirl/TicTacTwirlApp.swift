//
//  TicTacTwirlApp.swift
//  TicTacTwirl
//
//  Created by Eric Chandonnet on 2024-10-16.
//

import SwiftUI

@main
struct TicTacTwirlApp: App {
    @State var gameViewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gameViewModel)
                .statusBarHidden(true)
        }
    }
}
