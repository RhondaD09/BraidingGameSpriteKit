//
//  puzzleView.swift
//  BraidingGameSpriteKit
//
//  Created by Alexus WIlliams on 2/16/26.
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
        
        ZStack {
            //bedroom background
            Image("photoBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
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
                            .frame(width: 250)
                            .scaleEffect(showFinishedPhoto ? 1 : 0.5)
                            .animation(.easeOut(duration: 0.6), value: showFinishedPhoto)
                            .onAppear {
                                showFinishedPhoto = true
                            }
                    }
                }
                    .onAppear {
                        createPuzzle()
                    }
            }
        //body ends here
    
            //Create puzzle
            func createPuzzle() {
                
                pieces.removeAll()
                
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                
                for row in 0..<gridRows {
                    for col in 0..<gridColumns {
                        
                        let startX = (screenWidth - (CGFloat(gridColumns) * pieceSize)) / 2
                        let startY = (screenHeight - (CGFloat(gridRows) * pieceSize)) / 2
                        
                        let correctX = startX + CGFloat(col) * pieceSize + pieceSize/2
                        let correctY = startY + CGFloat(row) * pieceSize + pieceSize/2
                        
                        // scatter on screen
                        let randomX = CGFloat.random(in: pieceSize/2...(screenWidth - pieceSize/2))
                        let randomY = CGFloat.random(in: pieceSize/2...(screenHeight - pieceSize/2))
                        
                        let piece = PuzzlePiece(
                            position: CGPoint(x: randomX, y: randomY),
                            correctPosition: CGPoint(x: correctX, y: correctY))
                        
                        pieces.append(piece)
                    }
                }
                }
                
                
                //Snap into place
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
                }
                
                //Check completion
                func checkPuzzleComplete() {
                    
                    let allPlaced = pieces.allSatisfy { piece in
                        piece.position == piece.correctPosition
                    }
                    
                    if allPlaced {
                        puzzleComplete = true
                    }
                }
            }
            
            #Preview {
                PuzzleView()
            }
            
