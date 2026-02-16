//
//  MouthSceneView.swift
//  BraidingGameSpriteKit
//
//  Created by Rhonda Davis on 2/10/26.
//

import SwiftUI
import SpriteKit

struct MouthSceneView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var scene: MouthScene = {
        let scene = MouthScene(size: CGSize(width: 1024, height: 768))
        scene.scaleMode = .aspectFill
        return scene
    }()

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("circle_chevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 24)
                }
                Spacer()
            }
            
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        MouthSceneView()
    }
}

