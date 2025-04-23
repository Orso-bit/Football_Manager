//
//  BackCardView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 22/04/25.
//

import SwiftUI
import SwiftData

struct BackCardView: View {
    @Environment(\.modelContext) private var context
    var player: Player

    @State private var showPicker = false
    @State private var tempValue = 0
    @State private var selectedStat: StatType?

    enum StatType: String {
        case goals = "Goals"
        case presence = "Presence"
        case assists = "Assists"
        case woodworks = "Woodwork"
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 225/255, green: 238/255, blue: 188/255))
                .frame(width: 350, height: 400)
                .shadow(radius: 10)

            VStack {
                HStack {
                    statCard(for: .goals, value: player.goals)
                        .padding()
                    statCard(for: .presence, value: player.presence)
                        .padding()
                }
                .shadow(radius: 10)
                .padding()

                HStack {
                    statCard(for: .assists, value: player.assists)
                        .padding()
                    statCard(for: .woodworks, value: player.woodworks)
                        .padding()
                }
                .shadow(radius: 10)
                .padding()
            }
            .font(.system(size: 18))
            .bold()
        }
        .sheet(isPresented: $showPicker, onDismiss: {
            guard let selectedStat else { return }

            switch selectedStat {
            case .goals: player.goals = tempValue
            case .presence: player.presence = tempValue
            case .assists: player.assists = tempValue
            case .woodworks: player.woodworks = tempValue
            }

            try? context.save()
        }) {
            VStack(spacing: 20) {
                Text("Select \(selectedStat?.rawValue ?? "")")
                    .font(.title2)
                    .padding()

                Picker("Value", selection: $tempValue) {
                    ForEach(0...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .labelsHidden()
                .pickerStyle(WheelPickerStyle())

                Button("Done") {
                    showPicker = false
                }
                .padding()
            }
            .presentationDetents([.fraction(0.35)])
        }
    }

    func statCard(for type: StatType, value: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 103/255, green: 174/255, blue: 110/255))
                .frame(width: 120, height: 120)
            VStack {
                Text("\(value)")
                    .font(.system(size: 50, weight: .bold))
                Text(type.rawValue)
            }
        }
        .onTapGesture {
            selectedStat = type
            tempValue = value
            showPicker = true
        }
    }
}

#Preview {
    BackCardView(player: Player(name: "John", surname: "Doe", weight: 65, height: 175, preferredFoot: "Right", agility: "High", endurance: "Medium", speed: "High", strength: "Medium", verticalJump: "High", role: "Defender", assists: 3, goals: 0, woodworks: 4, presence: 5))
}
