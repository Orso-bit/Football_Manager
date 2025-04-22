//
//  FrontBackCardView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 22/04/25.
//

import SwiftUI

struct FrontBackCardView: View {
    @State private var isFlipped = false

    var player = Player(name: "John", surname: "Doe", weight: 65, height: 175, preferredFoot: "Right", agility: "High", endurance: "Medium", speed: "High", strength: "Medium", verticalJump: "High", role: "Defender", assists: 3, goals: 0, woodworks: 4, presence: 5)

    var body: some View {
        ZStack {
            PlayerCardView(player: player)
                .opacity(isFlipped ? 0.0 : 1.0)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .allowsHitTesting(!isFlipped) // Toccabile solo quando non è girata

            BackCardView()
                .opacity(isFlipped ? 1.0 : 0.0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .allowsHitTesting(isFlipped) // Toccabile solo quando è girata
        }
        .frame(width: 350, height: 400)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                isFlipped.toggle()
            }
        }
    }
}

#Preview {
    FrontBackCardView()
}
