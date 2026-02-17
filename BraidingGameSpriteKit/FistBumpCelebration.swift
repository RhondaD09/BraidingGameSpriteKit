//
//  FistBumpCelebration.swift
//  BraidingGameSpriteKit
//
//  Created by Rhonda Davis on 2/15/26.
//

import Foundation
import SpriteKit
import AVFoundation

final class FistBumpCelebration {

    private var running = false
    private var observer: NSObjectProtocol?

    /// Plays fistbumpanimated1.mov as a full-screen SpriteKit celebration with "hip-hop energy"
    func play(in scene: SKScene) {
        guard !running else { return }
        running = true

        let originalPosition = scene.position
        
        scene.run(.sequence([
            .moveBy(x: 12, y: 0, duration: 0.03),
            .moveBy(x: -18, y: 6, duration: 0.03),
            .moveBy(x: 10, y: -6, duration: 0.03),
            .move(to: originalPosition, duration: 0.03)
        ]))
        
        
        guard let url = Bundle.main.url(forResource: "fist", withExtension: "mov") else {
            print("⚠️ Could not find fist.mov (check target membership)")
            running = false
            return
        }

        // Dim background
        let dim = SKSpriteNode(color: .black, size: scene.size)
        dim.alpha = 0.0
        dim.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        dim.zPosition = 1900
        scene.addChild(dim)
        dim.run(.fadeAlpha(to: 0.55, duration: 0.12))

        // Video node
        let player = AVPlayer(url: url)
        let videoNode = SKVideoNode(avPlayer: player)
        videoNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        videoNode.size = scene.size
        videoNode.zPosition = 2000
        videoNode.alpha = 0.0
        scene.addChild(videoNode)
        videoNode.run(.fadeIn(withDuration: 0.10))
        
        
        let pulse = SKAction.sequence([
            .scale(to: 1.08, duration: 0.08),
            .scale(to: 1.0, duration: 0.08)
        ])
        videoNode.run(pulse)

        
        
        // 🔥 Firework burst
        if let firework = SKEmitterNode(fileNamed: "FireworkBurst.sks") {
            firework.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
            firework.zPosition = 1950
            scene.addChild(firework)

            firework.run(.sequence([
                .wait(forDuration: 0.6),
                .removeFromParent()
            ]))
        }

        // 🎉 Confetti rain
        if let confetti = SKEmitterNode(fileNamed: "Confetti.sks") {
            confetti.position = CGPoint(x: scene.size.width/2, y: scene.size.height)
            confetti.zPosition = 1940
            scene.addChild(confetti)

            confetti.run(.sequence([
                .wait(forDuration: 3.0),
                .removeFromParent()
            ]))
        }

        

        // Hype text
        let hype = SKLabelNode(text: "Let's Go!")
        // Prefer custom font if available; otherwise use a bold system-like fallback
        hype.fontName = UIFont(name: "Retrowave", size: 70)?.fontName ?? "Retrowave"
        hype.fontSize = 72
        hype.fontColor = .systemYellow
        hype.position = CGPoint(x: scene.size.width/2, y: scene.size.height*0.72)
        hype.zPosition = 2100
        hype.alpha = 0.0
        hype.setScale(0.5)
        scene.addChild(hype)

        let hypeIn = SKAction.group([
            .fadeIn(withDuration: 0.12),
            .scale(to: 1.2, duration: 0.12)
        ])
        
        
        let hypeBounce = SKAction.sequence([
            .scale(to: 1.0, duration: 0.08),
            .scale(to: 1.1, duration: 0.08),
            .scale(to: 1.0, duration: 0.08),
            
        ])
        
        hype.run(.sequence([hypeIn, hypeBounce]))
        
        
        hypeIn.timingMode = .easeOut

        let hypeSettle = SKAction.scale(to: 1.0, duration: 0.12)
        hypeSettle.timingMode = .easeOut

        let hypePulse = SKAction.sequence([
            .scale(to: 1.06, duration: 0.10),
            .scale(to: 1.0, duration: 0.10)
        ])

        hype.run(.sequence([hypeIn, hypeSettle, .repeat(hypePulse, count: 4)]))

        // Tiny shake on the dim layer (safe + visible)
        dim.run(.sequence([
            .moveBy(x: 10, y: 0, duration: 0.03),
            .moveBy(x: -18, y: 6, duration: 0.03),
            .moveBy(x: 14, y: -8, duration: 0.03),
            .moveBy(x: -6, y: 2, duration: 0.03),
            .moveBy(x: 0, y: 0, duration: 0.0)
        ]))

        // Cleanup old observer if any
        if let obs = observer {
            NotificationCenter.default.removeObserver(obs)
            observer = nil
        }

        // Play video
        player.play()

        observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }

            let fadeOut = SKAction.fadeOut(withDuration: 0.18)

            videoNode.run(.sequence([fadeOut, .removeFromParent()]))
            hype.run(.sequence([fadeOut, .removeFromParent()]))
            dim.run(.sequence([fadeOut, .removeFromParent()]))

            if let obs = self.observer {
                NotificationCenter.default.removeObserver(obs)
                self.observer = nil
            }

            
            
            self.running = false
            print("🎉 Fistbump celebration finished")
        }
    }
}

