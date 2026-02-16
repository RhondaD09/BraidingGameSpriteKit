//
//  LuxuryFX.swift
//  BraidingGameSpriteKit
//
//  Created by Rhonda Davis on 2/15/26.
//

import SpriteKit

final class LuxuryFX {

    func playSnapFX(in scene: SKScene, at position: CGPoint) {

        // Soft shine ring
        let ring = SKShapeNode(circleOfRadius: 18)
        ring.strokeColor = .white
        ring.lineWidth = 3
        ring.fillColor = .clear
        ring.alpha = 0.0
        ring.position = position
        ring.zPosition = 1500
        scene.addChild(ring)

        ring.run(.sequence([
            .fadeIn(withDuration: 0.06),
            .group([
                .scale(to: 1.8, duration: 0.20),
                .fadeOut(withDuration: 0.20)
            ]),
            .removeFromParent()
        ]))

        // Sparkle dots
        for _ in 0..<6 {
            let dot = SKShapeNode(circleOfRadius: 2.5)
            dot.fillColor = .white
            dot.strokeColor = .clear
            dot.alpha = 0.9
            dot.position = position
            dot.zPosition = 1500
            scene.addChild(dot)

            let angle = CGFloat.random(in: 0...(2 * .pi))
            let radius = CGFloat.random(in: 18...40)
            let dx = cos(angle) * radius
            let dy = sin(angle) * radius

            dot.run(.sequence([
                .group([
                    .moveBy(x: dx, y: dy, duration: 0.22),
                    .fadeOut(withDuration: 0.22)
                ]),
                .removeFromParent()
            ]))
        }
    }
}
