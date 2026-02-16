//
//  KitchenScene.swift
//  BraidingGameSpriteKit
//
//  Created by Rhonda Davis on 2/4/26.
//

import SpriteKit
import SwiftUI
import UIKit

//Safe texture loader

private func safeTexture(
    named name: String,
    maxDimension: CGFloat = 2048
) -> SKTexture? {
    guard let image = UIImage(named: name) else {
        print("⚠️ [KitchenScene] Missing image asset named '\(name)'")
        return nil
    }

    let originalSize = image.size
    let maxSide = max(originalSize.width, originalSize.height)

    let finalImage: UIImage

    if maxSide > maxDimension {
        let scale = maxDimension / maxSide
        let newSize = CGSize(
            width: originalSize.width * scale,
            height: originalSize.height * scale
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        finalImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        print("ℹ️ [KitchenScene] Downscaled '\(name)' from \(originalSize) to \(newSize)")
    } else {
        finalImage = image
    }

    return SKTexture(image: finalImage)
}

//SpriteKit Scene

class KitchenScene: SKScene {
    
    //Greens configuration
    
    //Texture names in order of chopping progress.
    private let greensStageTextureNames = [
        "whole_green",     // stage 0
        "cutup_greens",    // stage 1
        "cutup_greens2",   // stage 2
        "cutup_greens3"    // stage 3
    ]
    
    /// Chop thresholds for each stage (with requiredChops = 10):
    /// progress 0      -> stage 0 (whole)
    /// progress 1...3  -> stage 1
    /// progress 4...7  -> stage 2
    /// progress 8...10 -> stage 3
    private var greensStageThresholds: [Int] = []
    
    //All greens nodes in the same order as `greensStageTextureNames`
    private var greensNodes: [SKSpriteNode] = []
    
    //Green pick tool
    private var greenPickNode: SKSpriteNode?
    
    // Knife
    private var knifeNode: SKSpriteNode?
    
    // Chop state
    private var chopCount = 0
    private let requiredChops = 10
    private var isChopping = false
    
    // Sound
    private var chopSound: SKAction?
    
    // Celebration callback to SwiftUI
    var onGreensChopped: (() -> Void)?
    private var hasReportedGreensChopped = false
    
    private func reportGreensChoppedToSwiftUI() {
        guard !hasReportedGreensChopped else { return }
        hasReportedGreensChopped = true
        onGreensChopped?()
    }
    
    //Scene Life Cycle
    
    override func didMove(to view: SKView) {
        anchorPoint = .zero
        
        // Build thresholds once
        greensStageThresholds = [
            0,
            3,
            7,
            requiredChops
        ]
        
        setupBackground()
        setupCountertop()
        setupBoardAndGreens()
        setupKnife()
        setupSound()
    }
    
    //Setup
    
    private func setupBackground() {
        guard let texture = safeTexture(named: "kitchen_scene", maxDimension: 4000) else {
            backgroundColor = .black
            return
        }
        
        let node = SKSpriteNode(texture: texture)
        node.position = CGPoint(x: size.width * 0.5,
                                y: size.height * 0.5)
        node.zPosition = 0
        node.size = size
        addChild(node)
    }
    
    private func setupCountertop() {
        guard let texture = safeTexture(named: "countertop_dark") else { return }
        
        let node = SKSpriteNode(texture: texture)
        let targetWidth = size.width * 1.6
        let scale = targetWidth / node.size.width
        node.setScale(scale)
        
        node.position = CGPoint(
            x: size.width * 0.49,
            y: size.height * 0.25
        )
        node.zPosition = 1.9
        addChild(node)
    }
    
    private func setupBoardAndGreens() {
        guard let boardTexture = safeTexture(named: "cutting_board") else { return }
        
        let board = SKSpriteNode(texture: boardTexture)
        let targetBoardWidth = size.width * 0.6
        let boardScale = targetBoardWidth / board.size.width
        board.setScale(boardScale)
        
        board.position = CGPoint(
            x: size.width * 0.4,
            y: size.height * 0.40
        )
        board.zPosition = 3
        addChild(board)
        
        // Base position for all greens stages
        let greensY = board.position.y + board.size.height * 0.1
        let greensPosition = CGPoint(x: board.position.x, y: greensY)
        
        greensNodes.removeAll()
        
        // Create one node per stage from the names list
        for (index, textureName) in greensStageTextureNames.enumerated() {
            guard let texture = safeTexture(named: textureName) else {
                print("⚠️ Failed to load greens stage texture: \(textureName)")
                continue
            }
            
            let node = SKSpriteNode(texture: texture)
            
            // Per-stage scale (tweak as needed)
            let baseScale: CGFloat = {
                switch index {
                case 0: return 0.2  // whole
                case 1: return 0.25
                case 2: return 0.3
                case 3: return 0.4
                default: return 0.25
                }
            }()
            
            node.setScale(baseScale)
            node.position = greensPosition
            node.zPosition = 3
            
            // Only the first stage (whole) is visible initially
            node.alpha = (index == 0 ? 1.0 : 0.0)
            
            addChild(node)
            greensNodes.append(node)
        }
        
        // 👉 green_pick tool on the board (very visible)
        if let pickTexture = safeTexture(named: "green_pick") {
            let pick = SKSpriteNode(texture: pickTexture)
            pick.setScale(0.3)   // make it a bit bigger so we can't miss it
            
            // Put it just above the greens, in the middle of the board
            pick.position = CGPoint(
                x: board.position.x,
                y: greensPosition.y + board.size.height * 0.15
            )
            
            pick.zPosition = 10   // above board + greens
            addChild(pick)
            greenPickNode = pick
            
            print("✅ green_pick added at position \(pick.position), scale \(pick.xScale)")
        } else {
            print("❌ Could not create green_pick sprite (texture missing?)")
        }
    }
    
    private func setupKnife() {
        let knifeTexture = SKTexture(imageNamed: "knife")
        let knife = SKSpriteNode(texture: knifeTexture)
        knife.name = "knife"
        knife.setScale(0.5)
        knife.zRotation = .pi / 3
        knife.zPosition = 20
        
        // Default position if for some reason we have no greens
        var position = CGPoint(
            x: size.width * 0.5,
            y: size.height * 0.4
        )
        
        if let firstGreens = greensNodes.first {
            let yAboveGreens = firstGreens.position.y + firstGreens.size.height * 0.25
            position = CGPoint(x: firstGreens.position.x, y: yAboveGreens)
        }
        
        knife.position = position
        addChild(knife)
        knifeNode = knife
    }
    
    private func setupSound() {
        if Bundle.main.path(forResource: "knife_chop_short.wav", ofType: "wav") != nil {
            chopSound = SKAction.playSoundFileNamed("knife_chop_short.wav", waitForCompletion: false)
        } else {
            print("knife_chop_short.wav not found in bundle")
            chopSound = nil
        }
    }
    
    //Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if greensAreaContains(location) {
            performChop()
        }
    }
    
    private func greensAreaContains(_ point: CGPoint) -> Bool {
        return greensNodes.contains { node in
            node.alpha > 0 && node.contains(point)
        }
    }
    
    //Chop Logic
    
    private func performChop() {
        guard !isChopping else { return }
        
        guard let knife = knifeNode else {
            // No knife? Still show greens progress.
            updateGreensForCurrentChop()
            return
        }
        
        isChopping = true
        chopCount += 1
        
        playChopHaptic()
        
        let down = SKAction.moveBy(x: 0, y: -60, duration: 0.08)
        down.timingMode = .easeIn
        let up = down.reversed()
        up.timingMode = .easeOut
        
        let motion = SKAction.sequence([down, up])
        let sound = chopSound ?? SKAction.wait(forDuration: 0)
        let group = SKAction.group([motion, sound])
        
        let updateGreens = SKAction.run { [weak self] in
            self?.updateGreensForCurrentChop()
        }
        
        let done = SKAction.run { [weak self] in
            self?.isChopping = false
        }
        
        knife.run(SKAction.sequence([group, updateGreens, done]))
    }
    
    //Map the current chop progress to a stage index (0...greensNodes.count-1)
    private func stageIndex(for progress: Int) -> Int {
        guard !greensStageThresholds.isEmpty else { return 0 }
        
        for (index, threshold) in greensStageThresholds.enumerated() {
            if progress <= threshold {
                return min(index, greensNodes.count - 1)
            }
        }
        
        return greensNodes.count - 1
    }
    
    private func updateGreensForCurrentChop() {
        // If there's no knife, let progress still advance over time
        chopCount += (knifeNode == nil ? 1 : 0)
        let progress = min(chopCount, requiredChops)
        
        let currentStage = stageIndex(for: progress)
        
        // Show only the node for the current stage
        for (index, node) in greensNodes.enumerated() {
            node.alpha = (index == currentStage ? 1.0 : 0.0)
        }
        
        // Finished?
        if progress >= requiredChops {
            showCompletedBadge()
        }
    }
    
    //Celebration
    
    private func showCompletedBadge() {
        
        reportGreensChoppedToSwiftUI()
        
        if childNode(withName: "completeLabel") != nil { return }
        
        let label = SKLabelNode(text: "Greens Chopped!")
        label.name = "completeLabel"
        label.fontName = "Retrowave"
        label.fontSize = 65
        label.fontColor = .white
        label.zPosition = 200
        label.alpha = 0
        
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .top
        label.position = CGPoint(
            x: size.width / 2,
            y: size.height / 3
        )
        
        addChild(label)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        let pop = SKAction.scale(to: 1.15, duration: 0.25)
        pop.timingMode = .easeOut
        
        label.run(SKAction.sequence([fadeIn, pop]))
        
        // Tell SwiftUI to show CelebrationView
        reportGreensChoppedToSwiftUI()
    }
    
    private func playChopHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    
    }
}

#Preview {
    SpriteView(scene: KitchenScene(size: CGSize(width: 1024, height: 768)))
        .ignoresSafeArea()
}
