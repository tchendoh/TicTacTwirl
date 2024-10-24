//
//  SpinningCircleView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-19.
//

import SwiftUI

struct SpinningCircleView: View {
    @Environment(GameViewModel.self) private var gameViewModel: GameViewModel

    var isReversed: Bool = false

    @State private var isAnimating: Bool = false
    @State private var isPressed: Bool = false
    @State private var circleHeight: CGFloat = 120
        
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    ArcShape(startAngle: .degrees(10), endAngle: .degrees(330))
                        .stroke(Color(isReversed ? "TeamRed1" : "TeamBlue1"), style: StrokeStyle(lineWidth: circleHeight / 5, lineCap: .round))
                        .frame(width: circleHeight - 10, height: circleHeight - 10)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1.6).repeatForever(autoreverses: false), value: UUID())
                        .onAppear {
                            isAnimating = true
                        }
                        .opacity(isPressed ? 1 : 0)
                        .shadow(color: Color(isReversed ? "TeamRed1" : "TeamBlue1"), radius: 4)
                    
                    Image(systemName: "touchid")
                        .font(.system(size: circleHeight * 0.5))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color(isReversed ? "TeamRed1" : "TeamBlue1"), Color(isReversed ? "TeamRed1" : "TeamBlue1"))
                        .shadow(color: Color(isReversed ? "TeamRed1" : "TeamBlue1"), radius: isPressed ? 4 : 0)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    isPressed = true
                                    
                                }
                                .onEnded { _ in
                                    isPressed = false
                                }
                        )
                }
                Spacer()
            }
            .onChange(of: isPressed) { _, newValue in
                if newValue == true {
                    if isReversed {
                        gameViewModel.setTopPlayerAsReady()
                    } else {
                        gameViewModel.setBottomPlayerAsReady()
                    }

                } else {
                    if isReversed {
                        gameViewModel.setTopPlayerAsNotReady()
                    } else {
                        gameViewModel.setBottomPlayerAsNotReady()
                    }
                }
            }

        }
    }
}

// Custom shape for drawing arcs
struct ArcShape: Shape {
    
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2,
                    startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}

#Preview {
    ZStack {
        Color("TeamBlue")
        SpinningCircleView()
    }
    .environment(GameViewModel())

}
