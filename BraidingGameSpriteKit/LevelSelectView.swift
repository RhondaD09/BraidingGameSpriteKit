//
//  LevelSelectView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 2/2/26.
//

import Foundation
import SwiftUI

struct LevelSelectView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background (green)
            Image("level_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                // Top row: Level 1, 2, 3
                HStack(spacing: 32) {

                    // 🔹 LEVEL 1 → Braiding game
                    NavigationLink {
                        BraidingGameView()
                    } label: {
                        Image("level_1")   // your Level 1 badge
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                    }

                    // 🔸 LEVEL 2 (placeholder for now)
                    Button {
                        // TODO: hook up Level 2 later
                    } label: {
                        Image("level_2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                    }
                    .disabled(true) // disable until you’re ready

                    // 🔸 LEVEL 3 (placeholder for now)
                    Button {
                        // TODO: hook up Level 3 later
                    } label: {
                        Image("level_3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                    }
                    .disabled(true)
                }
                .padding(.top, 40)

                Spacer()

                // Bottom home button
                Button {
                    dismiss() // goes back to Tap In screen
                } label: {
                    Image("home_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 40)
        }
    }
}
