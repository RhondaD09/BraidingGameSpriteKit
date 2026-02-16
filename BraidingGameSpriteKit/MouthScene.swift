//
//  MouthScene.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 2/10/26.
//

import SpriteKit
import UIKit
import SwiftUI

final class MouthScene: SKScene {

    // Background + mouth
    private var backgroundNode: SKSpriteNode?
    private var mouthNode: SKSpriteNode?

    // Teeth sprites (draggable)
    private var toothNodes: [SKSpriteNode] = []

    // Dragging
    private var selectedTooth: SKSpriteNode?
    private var dragOffset: CGPoint = .zero

    // Tooth asset names (draggables row)
    private let toothAssetNames = [
        "IN_teeth",
        "red_teeth",
        "star_teeth",
        "starheart_teeth",
        "TAP_teeth"
    ]

    // Slots + occupancy
    private var toothSlots: [CGPoint] = []
    private var slotOccupants: [SKSpriteNode?] = []
    private var correctSlotForTooth: [String: Int] = [:]

    // Effects
    private let luxuryFX = LuxuryFX()
    private let celebration = FistBumpCelebration()

    // MARK: - Scene Life Cycle

    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupBackground()
        setupMouth()
        setupSlots()   // ✅ DO NOT TOUCH your nx/ny adjustments (kept exactly below)
        setupTeeth()
    }

    // MARK: - Setup

    private func setupBackground() {
        guard let texture = safeTexture(named: "mouth_background") else {
            print("⚠️ Missing image: mouth_background")
            return
        }

        let bg = SKSpriteNode(texture: texture)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -10
        bg.size = size
        addChild(bg)
        backgroundNode = bg
    }

    private func setupMouth() {
        let texture = SKTexture(imageNamed: "mouth")
        let mouth = SKSpriteNode(texture: texture)
        mouth.zPosition = 0

        let textureSize = texture.size()
        let scaleX = (size.width * 0.9) / textureSize.width
        let scaleY = (size.height * 0.8) / textureSize.height
        let scale = min(scaleX, scaleY)

        mouth.setScale(scale)
        mouth.position = CGPoint(x: size.width / 2, y: size.height * 0.50)

        addChild(mouth)
        mouthNode = mouth
    }

    // ✅ Slot positions (UNCHANGED — exactly what you pasted)
    private func setupSlots() {
        toothSlots = [
            mouthPoint(nx: 0.29, ny: 0.66),  // 0 TAP (top left)
            mouthPoint(nx: 0.78, ny: 0.70),  // 1 starheart (top next)
            mouthPoint(nx: 0.26, ny: 0.404), // 2 red (bottom left)
            mouthPoint(nx: 0.495, ny: 0.465),// 3 IN (bottom middle)
            mouthPoint(nx: 0.83, ny: 0.25)   // 4 star (bottom right)
        ]

        slotOccupants = Array(repeating: nil, count: toothSlots.count)

        // ✅ Indices MUST match 0...4
        correctSlotForTooth = [
            "TAP_teeth": 0,
            "starheart_teeth": 1,
            "red_teeth": 2,
            "IN_teeth": 3,
            "star_teeth": 4
        ]
    }

    private func setupTeeth() {
        toothNodes.removeAll()

        let count = toothAssetNames.count
        let rowY = size.height * 0.2
        let spacing = size.width / CGFloat(count + 1)

        for (index, name) in toothAssetNames.enumerated() {
            let tex = SKTexture(imageNamed: name)
            let tooth = SKSpriteNode(texture: tex)

            tooth.name = name
            tooth.zPosition = 5
            tooth.setScale(0.35)
            tooth.physicsBody = nil

            let x = spacing * CGFloat(index + 1)
            tooth.position = CGPoint(x: x, y: rowY)

            tooth.userData = NSMutableDictionary()
            tooth.userData?["homePosition"] = tooth.position
            
            
            addChild(tooth)
            toothNodes.append(tooth)
        }
    }

    //Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        var closestTooth: SKSpriteNode?
        var closestDistance = CGFloat.greatestFiniteMagnitude

        for tooth in toothNodes {

            let dx = tooth.position.x - loc.x
            let dy = tooth.position.y - loc.y
            let dist = sqrt(dx*dx + dy*dy)

            if dist < closestDistance {
                closestDistance = dist
                closestTooth = tooth
            }
        }

        let selectionRadius: CGFloat = 150
        if let tooth = closestTooth, closestDistance <= selectionRadius {
            selectedTooth = tooth
            tooth.zPosition = 100

            let pos = tooth.position
            dragOffset = CGPoint(x: pos.x - loc.x, y: pos.y - loc.y)

            // ✅ IMPORTANT: Remove from previous slot if it was locked
            for i in 0..<slotOccupants.count {
                if slotOccupants[i] === tooth {
                    slotOccupants[i] = nil
                }
            }

        } else {
            selectedTooth = nil
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let tooth = selectedTooth else { return }
        let loc = touch.location(in: self)

        tooth.position = CGPoint(
            x: loc.x + dragOffset.x,
            y: loc.y + dragOffset.y
        )
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let tooth = selectedTooth else { return }

        tooth.zPosition = 5
        selectedTooth = nil

        guard let name = tooth.name,
              let slotIndex = correctSlotForTooth[name],
              slotIndex < toothSlots.count else {
            return
        }

        // If slot already occupied by a different tooth, do nothing
        if let occ = slotOccupants[slotIndex], occ !== tooth {
            return
        }

        let target = toothSlots[slotIndex]
        let dx = target.x - tooth.position.x
        let dy = target.y - tooth.position.y
        let distance = sqrt(dx*dx + dy*dy)

        let snapRadius: CGFloat = 160
        guard distance <= snapRadius else {
            sendToHome(tooth)
            return
        }


        // ✅ Snap + lock (stable registration)
        tooth.position = target
        
        for i in 0..<slotOccupants.count {
            if slotOccupants[i] === tooth {
                slotOccupants[i] = nil
            }
        }

        slotOccupants[slotIndex] = tooth

        
        // ✅ Clean & luxury snap effect
        luxuryFX.playSnapFX(in: self, at: target)

        // Tiny feedback pop (visual)
        let originalScale = tooth.xScale
        tooth.run(.sequence([
            .scale(to: originalScale * 1.12, duration: 0.08),
            .scale(to: originalScale, duration: 0.08)
        ]))

        
    
        // ✅ Celebration AFTER final snap
        let filledSlots = slotOccupants.compactMap { $0 }

        print("Filled slots:", filledSlots.count)

        if filledSlots.count == toothSlots.count {
            print("🎉 TRIGGERING CELEBRATION")
            celebration.play(in: self)
        }


    }

    private func sendToHome(_ tooth: SKSpriteNode) {

        guard let home = tooth.userData?["homePosition"] as? CGPoint else { return }

        let moveBack = SKAction.move(to: home, duration: 0.25)
        moveBack.timingMode = .easeOut

        let shake = SKAction.sequence([
            .rotate(byAngle: 0.08, duration: 0.05),
            .rotate(byAngle: -0.16, duration: 0.05),
            .rotate(byAngle: 0.08, duration: 0.05)
        ])

        tooth.run(.group([moveBack, shake]))
    }

    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedTooth?.zPosition = 5
        selectedTooth = nil
    }

    // Mouth Coordinate Helper

    private func mouthPoint(nx: CGFloat, ny: CGFloat) -> CGPoint {
        guard let mouth = mouthNode else { return .zero }
        let localX = (nx - 0.5) * mouth.size.width
        let localY = (ny - 0.5) * mouth.size.height
        return mouth.convert(CGPoint(x: localX, y: localY), to: self)
    }

    // Safe Texture Loader

    private func safeTexture(named name: String) -> SKTexture? {
        let tex = SKTexture(imageNamed: name)
        if tex.size() != .zero { return tex }

        if let img = UIImage(named: name) {
            return SKTexture(image: img)
        }

        return nil
    }
}

#Preview {
    NavigationStack {
        MouthSceneView()
    }
}
