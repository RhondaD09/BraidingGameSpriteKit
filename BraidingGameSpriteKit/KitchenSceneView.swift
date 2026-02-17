//
//KitchenSceneView.swift
//BraidingGameSpriteKit
//
//Created by Rhonda Davis on 2/1/26
//



import SwiftUI
import SpriteKit

struct KitchenSceneView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var showCelebration = false
    @State private var navigateToLevel3 = false

    // Keep a single instance of the scene
    @State private var scene: KitchenScene = {
        let scene = KitchenScene(size: CGSize(width: 1024, height: 768))
        scene.scaleMode = .aspectFill
        return scene
    }()

    var body: some View {
        ZStack {
            // 🔪 SpriteKit kitchen scene
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    // Connect SpriteKit → SwiftUI
                    scene.onGreensChopped = {
                        DispatchQueue.main.async {
                            showCelebration = true
                        }
                    }
                }
            
            // ⭕ Top-right exit button for the kitchen scene (optional)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()   // Back to LevelView
                    } label: {
                        Image("circle_chevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 24)
                }
                Spacer()
            }
            
            
            // 🎉 Celebration popup when greens are fully chopped
            if showCelebration {
                ZStack {
                    // Dim background behind popup
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 24) {
                        
                        Text("Greens Chopped!")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        // Your existing celebration animation
                        CelebrationView(
                            onGoToLevel3: {
                                showCelebration = false
                                navigateToLevel3 = true
                            }
                            
                        )
                        .frame(maxWidth: 400, maxHeight:400)
                        // 🧼 Reset button – goes back to LevelView
                        Button {
                            // hide popup
                            showCelebration = false
                            // go back to LevelView screen
                            dismiss()
                        } label: {
                            Image("reset_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                        }
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        
        .navigationDestination(isPresented: $navigateToLevel3) {
            MouthSceneView()
        }
        
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    KitchenSceneView()
}

