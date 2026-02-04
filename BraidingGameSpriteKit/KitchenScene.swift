//
//  KitchenScene.swift
//  BraidingGameSpriteKit
//
//  Created by Rhonda Davis on 2/4/26.
//

import SpriteKit
import SwiftUI

class KitchenScene: SKScene {
    private let background = SKSpriteNode(imageNamed: "kitchen_scene")
    

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        // Ensure the scene has an anchor point centered for easier positioning
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // Configure background once the scene has a valid size
        background.zPosition = -1000

        // Maintain the texture's aspect ratio while filling the scene's width
        if let texture = background.texture {
            let textureSize = texture.size()
            let aspect = textureSize.height / textureSize.width
            background.size = CGSize(width: size.width, height: size.width * aspect)
        } else {
            background.size = size
        }

        // Centered because of anchorPoint = (0.5, 0.5)
        background.position = .zero

        if background.parent == nil {
            addChild(background)
        }
    }

    override func didChangeSize(_ oldSize: CGSize) {
        // Update background size when the scene resizes (e.g., device rotation)
        if let texture = background.texture {
            let textureSize = texture.size()
            let aspect = textureSize.height / textureSize.width
            background.size = CGSize(width: size.width, height: size.width * aspect)
        } else {
            background.size = size
        }
        background.position = .zero
    }
}

#Preview {
    // Use SpriteView to preview an SKScene in SwiftUI
    SpriteView(scene: {
        let scene = KitchenScene()
        // Provide an explicit size for the preview
        scene.size = CGSize(width: 325, height: 520)
        scene.scaleMode = .resizeFill
        return scene
    }())
    .ignoresSafeArea()
}
