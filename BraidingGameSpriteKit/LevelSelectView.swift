//
//  LevelSelectView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 2/2/26.
//

import SwiftUI

struct LevelSelectView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            
            // FOREGROUND CONTENT
            VStack(spacing: 24) {
                
                // TOP ROW: hairpick back button
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("hairpick_back_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(radius: 4)
                    }
                    .padding(.leading, 24)
                    
                    Spacer()
                }
                .padding(.top, 24)
                
                // TITLE
                Text("Choose a Level")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                
                // LEVEL BUTTONS ROW — CENTERED
                HStack(spacing: 32) {
                    // Level 1 – Braiding
                    NavigationLink {
                        BraidsView()
                    } label: {
                        Image("level_1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                    }
                    
                    // Level 2 – Kitchen
                    NavigationLink {
                        KitchenSceneView()
                    } label: {
                        Image("level_2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                    }
                    
                    // Level 3 – Mouth & Grill
                    NavigationLink {
                        MouthSceneView()
                    } label: {
                        Image("level_3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                        // .opacity(0.35) // uncomment if you want it to look locked
                    }
                    
                    
//                    Level 4 - Puzzle
                    NavigationLink {
                        PuzzleView()
                    } label: {
                        Image("level_4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                    }
                }
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center)  // 🔹 center row
                
                Spacer()   // 🔥 pins everything toward the top
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("level_background")
                    .resizable()
                    .scaledToFill()
            )
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        LevelSelectView()
    }
}
