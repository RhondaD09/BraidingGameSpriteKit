//
//  BraidingScene.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 1/27/26.
//

import SpriteKit
import UIKit

class BraidingScene: SKScene {
    
    //Braid Progress / Order
    private var braid2Done = false
    private var braid3Done = false
    private var braid4Done = false
    
    private var braidOrder: [SKSpriteNode] = []
    private var nextRequiredIndex = 0
    
    private var braidTargetZone: CGRect = .zero
    
    // Nodes
    private var girlBase: SKSpriteNode!
    private var cornrowTop: SKSpriteNode!
    
    private var staticLeftBraid: SKSpriteNode!
    private var staticRightBraid: SKSpriteNode!
    
    private var centerBraidLeft: SKSpriteNode!
    private var centerBraidMiddle: SKSpriteNode!
    private var centerBraidRight: SKSpriteNode!
    
    private var selectedBraid: SKSpriteNode?
    private var touchOffset: CGPoint = .zero
    
    // Layout Controls (YOU CAN TUNE THESE)
    private let braidVerticalOffset: CGFloat = -28      // moves braids up/down
    private let braidHorizontalSpread: CGFloat = 44     // spacing between braids
    private let braidScale: CGFloat = 0.71              // braid length/size
    private let braidXOffset: CGFloat = -101             // moves all braids left/right
    
    //Scene Setup
    override func didMove(to view: SKView) {
        
        // BACKGROUND IMAGE
        let background = SKSpriteNode(imageNamed: "retro_background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1000
        background.size = CGSize(width: size.width, height: size.width * (background.texture!.size().height / background.texture!.size().width))

        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(background)
        
       
    
        
        
        setupGirl()
        setupCornrowCap()
        setupBraids()
    
        // Order: center left (2), center middle (3), center right (4)
        braidOrder = [centerBraidLeft, centerBraidMiddle, centerBraidRight]
        
        // Simple target zone under the head (tweak later if needed)
        let zoneWidth: CGFloat = 160
        let zoneHeight: CGFloat = 140
        braidTargetZone = CGRect(
            x: -zoneWidth / 2,
            y: girlBase.position.y - 220,
            width: zoneWidth,
            height: zoneHeight
        )
    }
    
    //Girl Base
    // Girl Base
    private func setupGirl() {
        girlBase = SKSpriteNode(imageNamed: "girl_back")

        // Make her large enough to be the main focus
        girlBase.setScale(0.20)   // adjust 0.28–0.34 if needed

        // CENTERED position
        let x = size.width * 0.50       // center horizontally
        let y = size.height * 0.2      // mid-lower area of the screen

        girlBase.position = CGPoint(x: x, y: y)
        girlBase.zPosition = 0
        
        addChild(girlBase)
    }

    
    
    //Cornrow Cap
    private func setupCornrowCap() {
        cornrowTop = SKSpriteNode(imageNamed: "cornrow_top")
        cornrowTop.setScale(0.46)
        
        let headTop = girlBase.position.y + (girlBase.size.height * 0.46)
        
        cornrowTop.position = CGPoint(
            x: girlBase.position.x,
            y: headTop
        )
        
        cornrowTop.zPosition = 1
        addChild(cornrowTop)
    }
    
    //Braids
    //Braids
    private func setupBraids() {
        // align braids directly under cornrow top
        let braidY = cornrowTop.position.y + braidVerticalOffset

        // center around the girl's head
        let centerX = girlBase.position.x + braidXOffset

        // left-to-right positions
        let x1 = centerX + (-braidHorizontalSpread * 2)
        let x2 = centerX + (-braidHorizontalSpread)
        let x3 = centerX + 0
        let x4 = centerX + braidHorizontalSpread
        let x5 = centerX + (braidHorizontalSpread * 2)

        staticLeftBraid   = makeBraid("braid_single_1", x: x1, y: braidY, z: 4)
        centerBraidLeft   = makeBraid("braid_single_1", x: x2, y: braidY, z: 10)
        centerBraidMiddle = makeBraid("braid_single_2", x: x3, y: braidY, z: 10)
        centerBraidRight  = makeBraid("braid_single_3", x: x4, y: braidY, z: 10)
        staticRightBraid  = makeBraid("braid_single_3", x: x5, y: braidY, z: 4)
    }

    @discardableResult
    private func makeBraid(_ name: String, x: CGFloat, y: CGFloat, z: CGFloat) -> SKSpriteNode {
    // Root node - logical braid handle (stays at scalp line)
        let root = SKSpriteNode(color: .clear, size: CGSize(width: 20, height: 20))
        root.position = CGPoint(x: x, y: y)
        root.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        root.zPosition = z
        addChild(root)
        
    // Actual braid sprite
        let braid = SKSpriteNode(imageNamed: name)
        braid.anchorPoint = CGPoint(x: 0.5, y: 1.0)   // top of braid
        braid.setScale(braidScale)
        braid.position = .zero                         // attached at root top
        root.addChild(braid)
        
        // Make root tappable with same footprint as the braid
        root.size = CGSize(width: braid.size.width, height: braid.size.height)
        
        return root
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let movable = [centerBraidLeft!, centerBraidMiddle!, centerBraidRight!]
        
        for root in movable {
            if root.contains(location) {
                selectedBraid = root
                touchOffset = CGPoint(
                    x: root.position.x - location.x,
                    y: root.position.y - location.y
                )
                root.zPosition = 167
                return
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let selectedBraid = selectedBraid else { return }
        
        let location = touch.location(in: self)
        
        // Horizontal drag only – keeps top aligned to cornrow line
        selectedBraid.position.x = location.x + touchOffset.x
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let braid = selectedBraid else { return }
        braid.zPosition = 150
        
        // Check if braid is inside target zone
        if braidTargetZone.contains(braid.position) {
            
            // Must braid in required order
            if braid == braidOrder[nextRequiredIndex] {
                
                // Mark braid as done
                if nextRequiredIndex == 0 { braid2Done = true }
                if nextRequiredIndex == 1 { braid3Done = true }
                if nextRequiredIndex == 2 { braid4Done = true }
                
                // Move braid to its final braided spot
                let finalX = braid.position.x
                let finalY = braid.position.y - 80
                
                let snap = SKAction.move(
                    to: CGPoint(x: finalX, y: finalY),
                    duration: 0.15
                )
                braid.run(snap)
                
                nextRequiredIndex += 1
                
                // All 3 center braids done → show level animation
                if braid2Done && braid3Done && braid4Done {
                    showLevelCompleteAnimation()
                }
                
            } else {
                // Feedback if wrong braid tried
                let shake = SKAction.sequence([
                    SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                    SKAction.moveBy(x: 20, y: 0, duration: 0.05),
                    SKAction.moveBy(x: -10, y: 0, duration: 0.05)
                ])
                braid.run(shake)
            }
        }
        
        selectedBraid = nil
    }
    
    // MARK: - Level Completion → Next Game
    private func goToNextGame() {
        print("🎉 All braids completed — move to next game!")
        
        let fade = SKTransition.fade(withDuration: 1.0)
        let nextScene = SKScene(size: size)
        nextScene.backgroundColor = .purple
        view?.presentScene(nextScene, transition: fade)
    }
    
    private func showLevelCompleteAnimation() {
        // Dim the background slightly
        let dim = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        dim.fillColor = .black
        dim.alpha = 0
        dim.zPosition = 500
        addChild(dim)
        
        let fadeDim = SKAction.fadeAlpha(to: 0.45, duration: 0.3)
        dim.run(fadeDim)
        
        // LEVEL COMPLETE label
        let label = SKLabelNode(text: "LEVEL COMPLETE!")
        label.fontName = "Avenir-Heavy"
        label.fontSize = 40
        label.fontColor = .white
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 600
        label.setScale(0.1)
        addChild(label)
        
        // pop-in animation
        let pop = SKAction.sequence([
            SKAction.scale(to: 1.3, duration: 0.25),
            SKAction.scale(to: 1.0, duration: 0.15)
        ])
        label.run(pop)
        
        // Confetti
        if let confetti = SKEmitterNode(fileNamed: "Confetti.sks") {
            confetti.position = CGPoint(x: 0, y: size.height / 2)
            confetti.zPosition = 550
            addChild(confetti)
        }
        
        // Delay → go to next game
        let wait = SKAction.wait(forDuration: 1.6)
        let next = SKAction.run { [weak self] in
            self?.goToNextGame()
        }
        
        run(SKAction.sequence([wait, next]))
    }
}

// MARK: - Preview
#if DEBUG
import SwiftUI

#Preview {
    SpriteView(scene: {
        let scene = BraidingScene()
        scene.size = CGSize(width: 430, height: 950)
        scene.scaleMode = .resizeFill
        return scene
    }())
    .ignoresSafeArea()
}
#endif
