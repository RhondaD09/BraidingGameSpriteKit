//
//  TapInIntroView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 1/27/26.
//

import SwiftUI

struct TapInIntroView: View {
    @State private var fingerOffset: CGFloat = -10
    @State private var buttonPressed = false
    @State private var goToBraids = false

    var body: some View {
        NavigationStack {
            ZStack {
                // 📸 BACKGROUND
                Color.black
                    .ignoresSafeArea()

                // 🎯 FOREGROUND CONTENT
                VStack(spacing: 20) {
                    Image("TapInLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 450)
                        .offset(y: fingerOffset)
                        .animation(
                            .easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true),
                            value: fingerOffset
                        )
                        .onAppear {
                            fingerOffset = -4
                        }
                        .onTapGesture {
                            tapAction()
                        }

                    Text("Tap to Start")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.headline)
                        .padding(.top, 10)
                        .opacity(buttonPressed ? 0 : 1)
                }
            }
            // 🚪 Navigation to braiding game
            .navigationDestination(isPresented: $goToBraids) {
                BraidingGameView()
            }
        }
    }

    // Tap Animation + Navigation
    private func tapAction() {
        buttonPressed = true

        withAnimation(.easeOut(duration: 0.15)) {
            fingerOffset = 5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            goToBraids = true
        }
    }
}

#Preview {
    TapInIntroView()
}
