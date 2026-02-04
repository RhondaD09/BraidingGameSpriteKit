//
//  CelebrationView.swift
//  BraidingGameSK
//
//  Created by Rhonda Davis on 2/3/26.
//

import SwiftUI

// MARK: - STAR SHAPE (for star confetti)

struct StarShape: Shape {
    let points: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.45

        var path = Path()
        var angle: Double = -.pi / 2
        let angleIncrement = 2 * .pi / Double(points * 2)
        var isOuter = true

        for i in 0..<(points * 2) {
            let radius = isOuter ? outerRadius : innerRadius
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }

            isOuter.toggle()
            angle += angleIncrement
        }

        path.closeSubpath()
        return path
    }
}

// MARK: - PARTICLE MODEL (stars + confetti)

struct Particle: Identifiable {
    let id = UUID()
    let angle: Double
    let distance: CGFloat
    let color: Color
    let size: CGFloat
    let isStar: Bool

    static func randomColor() -> Color {
        [
            .yellow, .pink, .purple, .blue,
            .orange, .mint, .red, .green
        ].randomElement()!
    }
}

// MARK: - PARTICLE VIEW

struct ParticleView: View {
    let particle: Particle

    @State private var radius: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            if particle.isStar {
                StarShape(points: 5)
                    .fill(particle.color)
            } else {
                RoundedRectangle(cornerRadius: 3)
                    .fill(particle.color)
            }
        }
        .frame(width: particle.size, height: particle.size)
        .offset(x: offsetX, y: offsetY)
        .opacity(opacity)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            withAnimation(.easeOut(duration: 1.3)) {
                radius = particle.distance
                opacity = 0
            }
            withAnimation(.linear(duration: 1.3)) {
                rotation = Double.random(in: -360...360)
            }
        }
    }

    private var offsetX: CGFloat {
        CGFloat(cos(particle.angle)) * radius
    }

    private var offsetY: CGFloat {
        CGFloat(sin(particle.angle)) * radius
    }
}

// MARK: - FIREWORK MODEL

struct Firework: Identifiable {
    let id = UUID()
    let angle: Double      // where around the jar
    let distance: CGFloat  // how far from jar center
    let color: Color
}

// MARK: - SIMPLE FIREWORK VIEW (glowing ring)

struct FireworkView: View {
    let firework: Firework

    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            firework.color.opacity(0.9),
                            firework.color.opacity(0.4),
                            firework.color.opacity(0.9)
                        ]),
                        center: .center
                    ),
                    lineWidth: 6
                )
                .blur(radius: 1.5)

            Circle()
                .stroke(firework.color.opacity(0.6), lineWidth: 2)
        }
        .frame(width: 180, height: 180)
        .scaleEffect(scale)
        .opacity(opacity)
        .offset(x: offsetX, y: offsetY)
        .onAppear {
            withAnimation(.easeOut(duration: 1.4)) {
                scale = 1
                opacity = 0
            }
        }
    }

    private var offsetX: CGFloat {
        CGFloat(cos(firework.angle)) * firework.distance
    }

    private var offsetY: CGFloat {
        CGFloat(sin(firework.angle)) * firework.distance
    }
}

// MARK: - MAIN CELEBRATION VIEW

struct CelebrationView: View {
    @State private var particles: [Particle] = []
    @State private var fireworks: [Firework] = []

    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()

            // Tap Magic hair grease jar
            Image("hair_grease")
                .resizable()
                .scaledToFit()
                .frame(width: 450, height: 450)
                .shadow(radius: 20)

            // Stars + confetti
            ForEach(particles) { particle in
                ParticleView(particle: particle)
            }

            // Firework rings
            ForEach(fireworks) { fw in
                FireworkView(firework: fw)
            }
        }
        .onAppear {
            spawnParticles()
            spawnFireworks()
        }
    }

    // MARK: - Spawn stars + confetti

    private func spawnParticles() {
        particles.removeAll()
        let total = 60

        for i in 0..<total {
            let delay = Double(i) * 0.02
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let angle = Double.random(in: 0...(2 * .pi))
                let distance = CGFloat.random(in: 160...320)
                let isStar = Bool.random()

                let particle = Particle(
                    angle: angle,
                    distance: distance,
                    color: Particle.randomColor(),
                    size: CGFloat.random(in: isStar ? 18...26 : 10...16),
                    isStar: isStar
                )

                particles.append(particle)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    particles.removeAll { $0.id == particle.id }
                }
            }
        }
    }

    // MARK: - Spawn fireworks

    private func spawnFireworks() {
        fireworks.removeAll()

        let colors: [Color] = [
            Color(red: 1.0, green: 0.84, blue: 0.4), // soft gold
            Color(red: 1.0, green: 0.74, blue: 0.2), // deeper gold
            Color(red: 1.0, green: 0.63, blue: 0.2)  // orange-gold
        ]

        let total = 4

        for i in 0..<total {
            let delay = Double(i) * 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let angle = Double.random(in: 0...(2 * .pi))
                let distance = CGFloat.random(in: 140...220)
                let color = colors.randomElement() ?? .yellow

                let fw = Firework(
                    angle: angle,
                    distance: distance,
                    color: color
                )

                fireworks.append(fw)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    fireworks.removeAll { $0.id == fw.id }
                }
            }
        }
    }
}

// MARK: - PREVIEW

#Preview {
    CelebrationView()
}
