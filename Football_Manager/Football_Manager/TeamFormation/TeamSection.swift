//
//  TeamSection.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 26/04/25.
//

import SwiftUI

struct TeamSection: View {
    let title: String
    @Binding var selectedPlayers: [Player?]
    @Binding var otherSelectedPlayers: [Player?]
    @Binding var selectedNumber: Int
    let allPlayers: [Player]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            ForEach(0..<selectedNumber, id: \.self) { index in
                HStack {
                    Menu {
                        let availablePlayers = allPlayers.filter { player in
                            (!selectedPlayers.contains(where: { $0?.id == player.id }) || selectedPlayers[index]?.id == player.id)
                            &&
                            !otherSelectedPlayers.contains(where: { $0?.id == player.id })
                        }
                        
                        ForEach(availablePlayers, id: \.id) { player in
                            Button("\(player.name) \(player.surname)") {
                                selectedPlayers[index] = player
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedPlayers[index]?.name ?? "Select Player \(index + 1)")
                                .foregroundColor(selectedPlayers[index] == nil ? .gray : .primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                    }
                    
                    if selectedPlayers[index] != nil {
                        Button(action: {
                            selectedPlayers[index] = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                        .padding(.leading, 4)
                    }
                }
            }
        }
    }
}
