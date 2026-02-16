//
//  CelebrationView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 2/3/26.
//

import SwiftUI


// CelebrationView (Jar + Fireworks + Confetti)




struct CelebrationView: View {
    @State private var pulse = false
    @State private var confettiFall = false

    var onGoToLevel3:  (() -> Void)?
    
    var body: some View {
        ZStack {

            // 🔥 Fireworks behind jar
            ForEach(0..<5) { index in
                FireworkBurst()
                    .rotationEffect(.degrees(Double(index) * 72))
                    .scaleEffect(pulse ? 1.2 : 0.85)
                    .opacity(pulse ? 1.0 : 0.5)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulse)
            }

            // 🎊 Falling confetti (layer 1)
            ConfettiLayer(delay: 0)
            ConfettiLayer(delay: 0.3)
            ConfettiLayer(delay: 0.6)

            // 🫙 Jar + Right On!
            VStack(spacing: 12) {
                
                Image("hair_grease")   // ⬅️ Make sure this matches your asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 325, height: 350)
                    .shadow(radius: 8)
                    .onTapGesture {
                        onGoToLevel3?()
                        
                    }
            }
        }
        .padding(40)
        .background(Color.clear)  // 🔑 Transparent
        .onAppear {
            pulse = true
        }
    }
}



import SwiftUI

// Jar + Fireworks + Confetti overlay (no background)

struct CelebrationJarOverlay: View {
    @State private var pulse = false

    var body: some View {
        ZStack {

            // 🔥 Fireworks behind jar
            ForEach(0..<5) { index in
                FireworkBurst()
                    .rotationEffect(Angle.degrees(Double(index) * 72))
                    .scaleEffect(pulse ? 1.2 : 0.85)
                    .opacity(pulse ? 1.0 : 0.5)
                    .animation(
                        Animation
                            .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: pulse
                    )
            }

            // Falling confetti layers
            ConfettiLayer(delay: 0)
            ConfettiLayer(delay: 0.3)
            ConfettiLayer(delay: 0.6)

            // Jar + text
            VStack(spacing: 12) {
                
                Image("hair_grease")   // ⬅️ make sure this matches your asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 275, height: 275)
                    .shadow(radius: 8)
            }
        }
        .padding(40)
        .background(Color.burntOrange)   // transparent, no black fullscreen background
        .onAppear {
            pulse = true
        }
    }
}

// FireworkBurst (dotted fireworks)

struct FireworkBurst: View {
    @State private var expand = false

    var body: some View {
        ZStack {
            ForEach(0..<12) { i in
                Circle()
                    .frame(width: 7, height: 7)
                    .offset(x: expand ? 135 : 20)
                    .rotationEffect(
                        Angle.degrees(Double(i) / 12.0 * 360.0)
                    )
            }
        }
        .foregroundColor(.orange)
        .opacity(0.9)
        .onAppear {
            withAnimation(
                Animation
                    .easeOut(duration: 0.7)
                    .repeatForever(autoreverses: false)
            ) {
                expand = true
            }
        }
    }
}

// ConfettiLayer (falling confetti)

struct ConfettiLayer: View {
    let delay: Double
    @State private var fall = false

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<20) { i in
                Rectangle()
                    .fill(randomConfettiColor())
                    .frame(width: 8, height: 14)
                    .rotationEffect(
                        fall
                        ? Angle.degrees(Double.random(in: 0...360))
                        : Angle.degrees(0)
                    )
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: fall ? geo.size.height + 40 : -40
                    )
                    .animation(
                        Animation
                            .interpolatingSpring(stiffness: 25, damping: 8)
                            .delay(delay + Double(i) * 0.05)
                            .repeatForever(autoreverses: false),
                        value: fall
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            fall = true
        }
    }

    private func randomConfettiColor() -> Color {
        let colors: [Color] = [.yellow, .red, .blue, .orange, .pink, .purple, .green]
        return colors.randomElement()!
    }
}



#Preview {
    CelebrationView()
        .background(Color.burntOrange)
}

