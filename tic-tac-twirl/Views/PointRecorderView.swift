//
//  PointRecorderView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-19.
//


import SwiftUI

struct PointRecorderView: View {
    @State private var scopePositions: [CGPoint] = []
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
            
            ForEach(scopePositions.indices, id: \.self) { index in
                Circle()
                    .frame(width: 250, height: 250)
                    .position(scopePositions[index])
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    self.scopePositions.append(value.location)
                }
                .onEnded { _ in
                    self.scopePositions = []
                }
        )
    }
}


#Preview {
    PointRecorderView()
}