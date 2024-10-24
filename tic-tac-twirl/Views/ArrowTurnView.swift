//
//  ArrowTurnView.swift
//  tic-tac-twirl
//
//  Created by Eric Chandonnet on 2024-10-19.
//

import SwiftUI

struct ArrowTurnView: View {
    @State var isArrowAnimating: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "arrowshape.down.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
                    .offset(y: isArrowAnimating ? 0 : -40)
                    .onAppear {
                        withAnimation(Animation.bouncy().repeatForever()) {
                            isArrowAnimating = true
                        }
                        
                    }
                
            }
        }
        
    }
}

#Preview {
    ZStack {
        Color.blue
        VStack {
            ArrowTurnView()
        }
    }
    
}
