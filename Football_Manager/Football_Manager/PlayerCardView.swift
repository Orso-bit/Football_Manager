//
//  PlayerCardView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 21/04/25.
//

import SwiftUI

struct PlayerCardView: View {
    var player: Player
    var body: some View {
        Spacer().frame(height: 60)
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 300, height: 300)
                .shadow(radius: 10)
            VStack {
                HStack {
                    if let imageData = player.profileImage,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.gray)
                    }
                    Spacer().frame(width: 30)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(player.name)
                                .bold()
                                .font(.title)
                            Text(player.surname)
                                .bold()
                                .font(.title)
                        }
                        Text("Role: \(player.role)")
                    }
                }
                Divider().frame(width: 250)
                Spacer().frame(height: 120)
            }
        }
        Spacer()
    }
}

#Preview {
    PlayerCardView(player: Player(name: "John", surname: "Doe", weight: 65, height: 175, preferredFoot: "Right", agility: "High", endurance: "Medium", speed: "High", strength: "Medium", verticalJump: "High", role: "Defender"))
}
