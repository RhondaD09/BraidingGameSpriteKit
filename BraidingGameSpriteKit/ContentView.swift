//
//  ContentView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 1/27/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background (if your Tap In screen had one)
                Color.black.ignoresSafeArea()

                VStack(spacing: 40) {

                    // 👉 Your original Tap In logo image
                    Image("TapInLogo")         // <--- change to your actual asset name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320)

                    // 👉 This navigates to the level select screen
                    NavigationLink {
                        LevelSelectView()
                    } label: {
                        Text("Tap In")
                            .font(.largeTitle.bold())
                            .padding(.horizontal, 40)
                            .padding(.vertical, 16)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
    

