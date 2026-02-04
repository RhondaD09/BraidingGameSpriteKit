//
//  BraidingGameContainer.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 1/27/26.
//

import SwiftUI
import SpriteKit

struct BraidingGameContainer: View {

    var body: some View {
        GeometryReader { geo in
            let size = geo.size

            SpriteView(scene: makeScene(size: size))
                .ignoresSafeArea()
        }
    }

    func makeScene(size: CGSize) -> SKScene {
        let scene = BraidingScene()
        scene.size = size
        scene.scaleMode = .resizeFill
        return scene
    }
}
