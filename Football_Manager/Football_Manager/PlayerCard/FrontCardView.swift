//
//  PlayerCardView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 21/04/25.
//

import SwiftUI

struct FrontCardView: View {
    @State private var degrees: Double = 0 // Variabile per gestire l'angolo di rotazione
    var player: Player
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color(red: 225/255, green: 238/255, blue: 188/255)  // RGB(225, 238, 188)
                )
                .frame(width: 350, height: 400)
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
                        }
                        Text("Role: \(player.role)")
                    }
                }
                .padding()
                HStack {
                    Text(String(format: "%0.0f kg", player.weight))
                        .font(.headline)
                    Spacer().frame(width: 90)
                    Text(String(format: "%0.0f cm", player.height))
                        .font(.headline)
                }
                Divider().frame(width: 300)
                    .padding()
                VStack {
                    HStack {
                        Image(systemName: "figure.gymnastics.circle.fill")
                            .foregroundStyle(getColor(for: "agility", value: player.agility))
                        Image(systemName: "battery.100percent.circle.fill")
                            .foregroundStyle(getColor(for: "endurance", value: player.endurance))
                        Image(systemName: "figure.run.circle.fill")
                            .foregroundStyle(getColor(for: "speed", value: player.speed))
                    }
                    HStack {
                        Image(systemName: "figure.strengthtraining.traditional.circle.fill")
                            .foregroundStyle(getColor(for: "strength", value: player.strength))
                        Image(systemName: "figure.jumprope.circle.fill")
                            .foregroundStyle(getColor(for: "verticalJump", value: player.verticalJump))
                    }
                }
                .font(.system(size: 80))
            }
        }
    }
    
    func getColor(for attribute: String, value: String) -> Color {
        switch attribute {
        case "agility":
            switch value {
            case "High": return .green
            case "Medium": return .yellow
            case "Low": return .red
            default: return .gray
            }
        case "endurance":
            switch value {
            case "High": return .green
            case "Medium": return .yellow
            case "Low": return .red
            default: return .gray
            }
        case "strength":
            switch value {
            case "High": return .green
            case "Medium": return .yellow
            case "Low": return .red
            default: return .gray
            }
        case "speed":
            switch value {
            case "High": return .green
            case "Medium": return .yellow
            case "Low": return .red
            default: return .gray
            }
        case "verticalJump":
            switch value {
            case "High": return .green
            case "Medium": return .yellow
            case "Low": return .red
            default: return .gray
            }
        default:
            return .gray
        }
    }
}

#Preview {
    FrontCardView(player: Player(name: "John", surname: "Doe", weight: 65, height: 175, preferredFoot: "Right", agility: "High", endurance: "Medium", speed: "High", strength: "Medium", verticalJump: "High", role: "Defender", assists: 3, goals: 0, woodworks: 4, presence: 5))
}
