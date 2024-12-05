//
//  SpinningCircleView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-19.
//

import SwiftUI
import CoreHaptics

struct SpinningCircleView: View {
    @Environment(GameViewModel.self) private var gameViewModel: GameViewModel
    
    var isReversed: Bool = false
    
    @State private var isRotating: Bool = false
    @State private var isPulsing: Bool = false
    @State private var isPressed: Bool = false
    @State private var circleHeight: CGFloat = 120
    @State private var counter = 0.0
    @State private var startTime = 0.0
    private let timeToBeReady = 3.7
    
    let timer = Timer.publish(every: 0.2, tolerance: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    ArcShape(startAngle: .degrees(10), endAngle: .degrees(330))
                        .stroke(Color(isReversed ? "TeamRed1" : "TeamBlue1"), style: StrokeStyle(lineWidth: circleHeight / 5, lineCap: .round))
                        .frame(width: circleHeight - 10, height: circleHeight - 10)
                        .rotationEffect(.degrees(isRotating ? 360 : 0))
                        .animation(.linear(duration: 1.6).repeatForever(autoreverses: false), value: isRotating)
                        .scaleEffect(isPulsing ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: isPulsing)
                        .onAppear {
                            isRotating = true
                            isPulsing = false
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
                                    setPlayerAsGettingReady()
                                    if gameViewModel.areBothPlayersGettingReady() {
                                        isPulsing = true
                                    }
                                }
                                .onEnded { _ in
                                    print("off")
                                    isPressed = false
                                    isPulsing = false
                                    setPlayerAsNotGettingReady()
                                    setPlayerAsNotReady()
                                }
                        )
                        .onReceive(timer) { _ in
                            counter += 0.2
                            if isPressed {
                                if counter - startTime  > timeToBeReady {
                                    setPlayerAsReady()
                                }
                            }
                        }
                        .onChange(of: isPressed) { oldValue, newValue in
                            if oldValue != newValue {
                                if isPressed {
                                    startTime = counter
                                }
                            }
                        }
                }
                Spacer()
                    
            }
//            Text("Counter : \(counter)")
//                .font(.title)
//            Text("Start time : \(startTime)")
//                .font(.title)
//            Text("Difference : \(isPressed ? counter - startTime : 0.0)")
//                .font(.title)
        }
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: isPressed)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.8), trigger: isPulsing)

    }
    
    func setPlayerAsReady() {
        if isReversed {
            gameViewModel.setTopPlayerAsReady()
        } else {
            gameViewModel.setBottomPlayerAsReady()
        }
    }
    func setPlayerAsNotReady() {
        if isReversed {
            gameViewModel.setTopPlayerAsNotReady()
        } else {
            gameViewModel.setBottomPlayerAsNotReady()
        }
    }
    func setPlayerAsGettingReady() {
        if isReversed {
            gameViewModel.setTopPlayerAsGettingReady()
        } else {
            gameViewModel.setBottomPlayerAsGettingReady()
        }
    }
    func setPlayerAsNotGettingReady() {
        if isReversed {
            gameViewModel.setTopPlayerAsNotGettingReady()
        } else {
            gameViewModel.setBottomPlayerAsNotGettingReady()
        }
    }

}

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
