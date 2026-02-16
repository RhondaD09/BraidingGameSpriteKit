//
//  beadsBraids.swift
//  BraidingGameSpriteKit
//
//  Created by Alexus WIlliams on 2/16/26.
//

import SpriteKit
import GameplayKit
import SwiftUI

class GameScene: SKScene {
    
    var girl: SKSpriteNode!
    var background: SKSpriteNode!
    var selectedBead: SKSpriteNode?
    var jar: SKSpriteNode!
    var beadsRemaining = 15   // 5 colors × 3 each
    // Each braid will hold beads placed on it
    var braidSlots: [[SKSpriteNode]] = Array(repeating: [], count: 5)
    var braidHighlights: [SKShapeNode] = []


    // Maxi beads per braid
    let beadsPerBraid = 3
    
    // Each braid accepts ONLY this bead color
    let braidAllowedColors = [
        "beadBlue",
        "beadPink",
        "beadRed",
        "beadGreen",
        "beadYellow"
    ]


    
    let braidPositions: [[CGPoint]] = [
        [CGPoint(x:-40,y:60), CGPoint(x:-40,y:40), CGPoint(x:-40,y:20)],
        [CGPoint(x:-20,y:60), CGPoint(x:-20,y:40), CGPoint(x:-20,y:20)],
        [CGPoint(x:0,y:60), CGPoint(x:0,y:40), CGPoint(x:0,y:20)],
        [CGPoint(x:20,y:60), CGPoint(x:20,y:40), CGPoint(x:20,y:20)],
        [CGPoint(x:40,y:60), CGPoint(x:40,y:40), CGPoint(x:40,y:20)]
    ]

    
    override func didMove(to view: SKView) {
        self.scaleMode = .resizeFill

        // Center the coordinate system
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        setupBackground()
        setupGirl()
        createHiddenHighlights()
//        setupJar()
        setupInitialBeads()
       
        
    }
    
    func setupGirl() {
        girl = SKSpriteNode(imageNamed: "girlBraids")
        
        // Bottom-center of screen
        let bottomY = -size.height / 2 + girl.size.height / 2 + 20
        girl.position = CGPoint(x: 0, y: bottomY)
        
        girl.setScale(0.7)
        girl.zPosition = -5
        
        addChild(girl)
    }
    
    func createHiddenHighlights() {

        for braid in braidPositions {

            let firstSlot = braid[0]

            let worldPosition = CGPoint(
                x: girl.position.x + firstSlot.x,
                y: girl.position.y + firstSlot.y
            )

            let glow = SKShapeNode(rectOf: CGSize(width: 40, height: 90))
            glow.strokeColor = .green
            glow.lineWidth = 4
            glow.alpha = 0    // invisible initially
            glow.position = worldPosition
            glow.zPosition = 50

            braidHighlights.append(glow)
            addChild(glow)
        }
    }
    
//    func setupBraidHighlights() {
//
//        for braid in braidPositions {
//
//            let firstSlot = braid[0]
//
//            let worldPosition = CGPoint(
//                x: girl.position.x + firstSlot.x,
//                y: girl.position.y + firstSlot.y
//            )
//
//            let box = SKShapeNode(rectOf: CGSize(width: 40, height: 90))
//            box.strokeColor = .yellow
//            box.lineWidth = 2
//            box.position = worldPosition
//            box.zPosition = 1
//
//            braidHighlights.append(box)
//            addChild(box)
//        }
//    }
    
//    func setupJar() {
//        jar = SKSpriteNode(imageNamed: "jarFull")
//        jar.position = CGPoint(x: 0, y: -size.height/2 + 80)
//        jar.zPosition = 5
//        jar.setScale(0.6)
//        addChild(jar)
//    }

    func setupInitialBeads() {

        let beadNames = ["beadBlue", "beadPink", "beadRed", "beadGreen", "beadYellow"]

        var xPos: CGFloat = -450
        let bottomY = -size.height / 2 + 80

        for beadName in beadNames {

            for _ in 0..<3 {   // 3 beads per color

                let bead = SKSpriteNode(imageNamed: beadName)

                bead.name = beadName
                bead.userData = ["color": beadName]

                bead.position = CGPoint(x: xPos, y: bottomY)
                bead.userData?["startPosition"] = NSValue(cgPoint: bead.position)

                bead.setScale(0.6)
                bead.zPosition = 20
                addChild(bead)

                xPos += 60
            }

            xPos += 20
        }
    }
    
    func setupBackground() {
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -10   // ALWAYS behind everything
        background.size = size
        addChild(background)
    }
    
    func updateJarVisual() {

        if beadsRemaining <= 0 { jar.texture = SKTexture(imageNamed: "jarEmpty") }
        else if beadsRemaining <= 7 { jar.texture = SKTexture(imageNamed: "jarHalf") }

    }

    
    func checkBraidCompletion(_ braidIndex: Int) {

        let beads = braidSlots[braidIndex]

        guard beads.count == beadsPerBraid else { return }

        let glow = braidHighlights[braidIndex]

        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.2)
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.6)

        glow.run(SKAction.sequence([fadeIn, fadeOut]))

        checkLevelCompletion()
        
        func checkBraidCompletion(_ braidIndex: Int) {
            
            let beads = braidSlots[braidIndex]
            guard beads.count == beadsPerBraid else { return }
            
            braidHighlights[braidIndex].strokeColor = .green
        }
    }
    
    func checkLevelCompletion() {

        for braid in braidSlots {
            if braid.count < beadsPerBraid {
                return
            }
        }

//        showLevelComplete()
    }
    
//    func showLevelComplete() {
//
//        let label = SKLabelNode(text: "Level Complete!")
//        label.fontSize = 44
//        label.fontColor = .white
//        label.position = CGPoint(x: 0, y: 0)
//        label.zPosition = 100
//
//        addChild(label)
//    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            if let sprite = node as? SKSpriteNode,
               sprite.name?.contains("bead") == true {

                selectedBead = sprite
                selectedBead?.zPosition = 100
                break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let bead = selectedBead else { return }
        
        bead.position = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let bead = selectedBead else { return }
        
        for (braidIndex, braid) in braidPositions.enumerated() {
            
            //checks if braid is full
            if braidSlots[braidIndex].count >= beadsPerBraid {
                continue
            }
            
            // colors lock onto a specific braid
            if bead.name != braidAllowedColors[braidIndex] {
                continue
            }
            
            let slotPosition = braid[braidSlots[braidIndex].count]
            
            let worldPosition = CGPoint(
                x: girl.position.x + slotPosition.x,
                y: girl.position.y + slotPosition.y
            )
            //Snap check
            let braidCenter = CGPoint(
                x: girl.position.x + braid[1].x,
                y: girl.position.y + braid[1].y
            )

            if bead.position.distance(to: braidCenter) < 120 {

            let slotPosition = braid[braidSlots[braidIndex].count]

                let worldPosition = CGPoint(
                    x: girl.position.x + slotPosition.x,
                    y: girl.position.y + slotPosition.y
                )

                let move = SKAction.move(to: worldPosition, duration: 0.25)
                move.timingMode = .easeOut
                bead.run(move)

                let clickSound = SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false)
                
                bead.zPosition = 10
                braidSlots[braidIndex].append(bead)

                checkBraidCompletion(braidIndex)

                selectedBead = nil
                return
            }

                
                let move = SKAction.move(to: worldPosition, duration: 0.25)
                move.timingMode = .easeOut

                bead.run(move)


                braidSlots[braidIndex].append(bead)

            beadsRemaining -= 1
            updateJarVisual()

                checkBraidCompletion(braidIndex)
                
            if let startValue = bead.userData?["startPosition"] as? NSValue {

                let startPosition = startValue.cgPointValue

                let moveBack = SKAction.move(to: startPosition, duration: 0.25)
                moveBack.timingMode = .easeOut
                bead.run(moveBack)
            }

            selectedBead = nil

            }
    }
}
        
extension CGPoint {
func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

