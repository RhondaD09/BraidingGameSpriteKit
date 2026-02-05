//
//  KitchenScene.swift
//  BraidingGameSpriteKit
//
//  Created by Rhonda Davis on 2/4/26.
//

import SpriteKit
import SwiftUI

class KitchenScene: SKScene {
    
    // MARK: - Nodes (optional for safety)
    private var backgroundNode: SKSpriteNode?
    private var countertopNode: SKSpriteNode?
    private var cuttingBoardNode: SKSpriteNode?
    private var greensNode: SKSpriteNode?
    
    // MARK: - Textures
    private let wholeGreensTexture  = SKTexture(imageNamed: "whole_green")
    
    // Layout flag
    private var isConfigured = false
    
    // MARK: - Scene Life Cycle
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        scaleMode = .resizeFill
        
        if !isConfigured {
            setupBackground()
            setupCountertop()
            setupCuttingBoard()
            setupGreens()
            isConfigured = true
            layoutNodes()
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        guard isConfigured else { return }
        layoutNodes()
    }
    
    // MARK: - Setup
    
    private func setupBackground() {
        let node = SKSpriteNode(imageNamed: "kitchen_scene")
        node.zPosition = -20
        addChild(node)
        backgroundNode = node
    }
    
    private func setupCountertop() {
        let node = SKSpriteNode(imageNamed: "countertop")
        node.zPosition = -10
        addChild(node)
        countertopNode = node
    }
    
    private func setupCuttingBoard() {
        let node = SKSpriteNode(imageNamed: "cutting_board")
        node.zPosition = -5
        addChild(node)
        cuttingBoardNode = node
    }
    
    private func setupGreens() {
        let node = SKSpriteNode(texture: wholeGreensTexture)
        node.zPosition = 0
        node.name = "greens"
        addChild(node)
        greensNode = node
    }
    
    // MARK: - Layout
    
    private func layoutNodes() {
        guard
            let backgroundNode,
            let countertopNode,
            let cuttingBoardNode,
            let greensNode
        else { return }
        
        let size = self.size
        
        // Background fills screen
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.size = size
        
        // Countertop at lower half
        let counterWidth = size.width
        let counterHeight = size.height * 0.45
        countertopNode.size = CGSize(width: counterWidth, height: counterHeight)
        countertopNode.position = CGPoint(
            x: size.width / 2,
            y: counterHeight / 2
        )
        
        // Cutting board on top of countertop
        let boardWidth = size.width * 0.7
        let boardHeight = boardWidth * 0.5
        cuttingBoardNode.size = CGSize(width: boardWidth, height: boardHeight)
        cuttingBoardNode.position = CGPoint(
            x: size.width / 2,
            y: countertopNode.position.y + counterHeight * 0.1
        )
        
        // Greens on top of board
        let greensWidth = boardWidth * 0.7
        let greensHeight = greensWidth * 0.5
        greensNode.size = CGSize(width: greensWidth, height: greensHeight)
        greensNode.position = cuttingBoardNode.position
    }
}

// MARK: - SwiftUI Preview Wrapper

struct KitchenSceneView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        
        // Use a fixed, non-zero size for preview
        let sceneSize = CGSize(width: 834, height: 1194) // iPad-ish
        let scene = KitchenScene(size: sceneSize)
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // No dynamic updates needed for preview
    }
}

#Preview {
    KitchenSceneView()
        .ignoresSafeArea()
}
