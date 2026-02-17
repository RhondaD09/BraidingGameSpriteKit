//
//  BraidingGameView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 1/29/26.
//

import SwiftUI
import SpriteKit

struct BraidingGameView: View {
    @Environment(\.dismiss) private var dismiss

    private func makeScene(size: CGSize) -> SKScene {
        let scene = BraidingScene(size: size)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            SpriteView(scene: makeScene(size: size))
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)   // ❗ hide chevron
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()                   // ❗ go back using hairpick
                } label: {
                    Image("hairpick_back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                }
            }
        }
    }
}
