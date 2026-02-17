//
//  puzzleView.swift
//  BraidingGameSpriteKit
//
//  Created by Alexus WIlliams on 2/17/26.
//

import SwiftUI

struct PuzzlePiece: Identifiable {
    let id = UUID()
    var position: CGPoint
    var correctPosition: CGPoint
    var locked: Bool = false
}

struct PuzzleView: View {
    
    @State private var pieces: [PuzzlePiece] = []
    @State private var puzzleComplete = false
    @State private var showFinishedPhoto = false
    
    
    
    let gridColumns = 3
    let gridRows = 4
    let pieceSize: CGFloat = 150
    
    let fullImage = UIImage(named: "teamPhoto")!
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                //bedroom background
                Image("photoBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                //visible frame for puzzle pieces
                ForEach(pieces) { piece in
                    Rectangle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 2.5) // Thin, semi-transparent white line
                        .frame(width: pieceSize, height: pieceSize)
                        .position(piece.correctPosition) // Place it exactly where the snap happens
                }
                
                //Puzzle pieces
                ForEach(pieces.indices, id: \.self) { index in
                    
                    let row = index / gridColumns
                    let col = index % gridColumns
                    
                    let cropWidth = fullImage.size.width / CGFloat(gridColumns)
                    let cropHeight = fullImage.size.height / CGFloat(gridRows)
                    
                    if let cgImage = fullImage.cgImage?.cropping(
                        to: CGRect(
                            x: CGFloat(col) * cropWidth,
                            y: CGFloat(row) * cropHeight,
                            width: cropWidth,
                            height: cropHeight)) {
                        
                        Image(uiImage: UIImage(cgImage: cgImage))
                            .resizable()
                            .frame(width: pieceSize, height: pieceSize)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.white.opacity(0.8), lineWidth: 1))
                            .shadow(radius: 4)
                            .position(pieces[index].position)
                        
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if !pieces[index].locked {
                                            pieces[index].position = value.location
                                        }
                                    }
                                    .onEnded { _ in
                                        if !pieces[index].locked {
                                            snapIntoPlace(index: index)
                                        }
                                    }
                            )
                    }
                }
                
                if puzzleComplete {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                    
                    Image("finishedPhoto")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 950)
                        .scaleEffect(showFinishedPhoto ? 1 : 0.5)
                        .animation(.easeOut(duration: 0.6), value: showFinishedPhoto)
                        .onAppear {
                            showFinishedPhoto = true
                        }
                }
            }
            .onAppear {
                createPuzzle(in: geo.size)
            }
        }
    }
//}
        //body ends here
    
//   Create puzzle
    func createPuzzle(in size: CGSize) {
        pieces.removeAll()
        
        let screenWidth = size.width
        let screenHeight = size.height
        
        let totalGridWidth = CGFloat(gridColumns) * pieceSize
        let totalGridHeight = CGFloat(gridRows) * pieceSize
        
        let startX = (screenWidth - totalGridWidth) / 2
        let startY = (screenHeight - totalGridHeight) / 2
        
        for row in 0..<gridRows {
            for col in 0..<gridColumns {
                let correctX = startX + (CGFloat(col) * pieceSize) + (pieceSize / 2)
                let correctY = startY + (CGFloat(row) * pieceSize) + (pieceSize / 2)
                
                let piece = PuzzlePiece(
                    position: CGPoint(
                        x: CGFloat.random(in: 100...screenWidth-100),
                        y: CGFloat.random(in: 100...screenHeight-100)
                    ),
                    correctPosition: CGPoint(x: correctX, y: correctY)
                )
                pieces.append(piece)
            }
        }
    } // This closes createPuzzle

    // Snap into place
    func snapIntoPlace(index: Int) {
        let piece = pieces[index]
        let distance = hypot(
            piece.position.x - piece.correctPosition.x,
            piece.position.y - piece.correctPosition.y
        )
        
        if distance < 50 {
            withAnimation(.easeOut(duration: 0.25)) {
                pieces[index].position = piece.correctPosition
                pieces[index].locked = true
            }
        }
        checkPuzzleComplete()
    } // This closes snapIntoPlace

    // Check completion
    func checkPuzzleComplete() {
        let allPlaced = pieces.allSatisfy { $0.locked }
        if allPlaced {
            puzzleComplete = true
        }
    } // This closes checkPuzzleComplete
    
} // closes the whole PuzzleView struct

#Preview {
    NavigationStack {
        PuzzleView()
        CelebrationView()
    }
}
