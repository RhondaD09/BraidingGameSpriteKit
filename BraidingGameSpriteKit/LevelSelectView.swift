//
//  LevelSelectView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 2/2/26.
//

//
//  LevelSelectView.swift
//  BraidingGameSK
//

import SwiftUI

struct LevelSelectView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // All foreground content goes in here
            VStack(spacing: 24) {

                // TOP ROW: hairpick back button
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("hairpick_back_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .shadow(radius: 4)
                    }
                    .padding(.leading, 24)

                    Spacer()
                }
                .padding(.top, 20)

                // Title
                Text("Choose a Level")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 3)

                // LEVEL CARDS ROW
                HStack(spacing: 32) {

                    // Level 1 – Braiding
                    NavigationLink {
                        BraidingGameView()
                    } label: {
                        levelCard(
                            imageName: "level_1",
                            label: "Level 1",
                            subtitle: "Braiding"
                        )
                    }

                    // Level 2 – Kitchen
                    NavigationLink {
                        KitchenSceneView()
                    } label: {
                        levelCard(
                            imageName: "level_2",
                            label: "Level 2",
                            subtitle: "Kitchen"
                        )
                    }

                    // Level 3 – Coming Soon
                    levelCard(
                        imageName: "level_3",
                        label: "Level 3",
                        subtitle: "Coming Soon"
                    )
                    .opacity(0.35)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.horizontal, 40)
        }
        // 👉 Put the background image BEHIND everything
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("level_background")
                .resizable()
                .scaledToFill()
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Reusable Level Card
    private func levelCard(imageName: String,
                           label: String,
                           subtitle: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.92))
                .shadow(radius: 4)

            VStack(spacing: 6) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)

                Text(label)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
        }
        .frame(width: 190, height: 150)
    }
}

#Preview {
    NavigationStack {
        LevelSelectView()
    }
}
