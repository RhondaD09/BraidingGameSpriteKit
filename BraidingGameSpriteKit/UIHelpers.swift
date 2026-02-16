//
//  UIHelpers.swift
//  BraidingGameSpriteKit
//
//  Created by Rhonda Davis on 2/5/26.
//

import Foundation
import SwiftUI

struct HairpickBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image("hairpick_back_button")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)   // tweak size if needed
                .contentShape(Rectangle())       // better tap target
        }
    }
}

extension View {
    func hairpickBackButton() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HairpickBackButton()
                }
            }
    }
}


