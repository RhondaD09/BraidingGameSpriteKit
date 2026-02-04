//
//  BraidingGameView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 1/29/26.
//

import SwiftUI
import SpriteKit

struct BraidingGameView: View {

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
        .navigationBarBackButtonHidden(false)
    }
}
