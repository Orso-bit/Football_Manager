//
//  PlayerListView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 21/04/25.
//

import SwiftUI

struct PlayerListView: View {
    var players: [Player]
    var filteredPlayers: [Player]
    var deletePlayers: (IndexSet) -> Void
    
    var body: some View {
        List {
            Section(header: Text("Players")) {
                ForEach(filteredPlayers) { player in
                    NavigationLink(destination: FrontBackCardView(player: player)) {
                        HStack {
                            if let imageData = player.profileImage,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color(.systemGray4))
                            }
                            VStack(alignment: .leading) {
                                Text("\(player.name) \(player.surname)")
                                    .font(.headline)
                                Text(player.role)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deletePlayers)
                .listRowBackground(Color(red: 225/255, green: 238/255, blue: 188/255))
            }
            .listRowBackground(Color.white.opacity(0.9))
        }
        .listRowSpacing(8.0)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 144/255, green: 198/255, blue: 124/255), // RGB(144, 198, 124)
                    Color(red: 103/255, green: 174/255, blue: 110/255)  // RGB(225, 238, 188)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .scrollContentBackground(.hidden)
    }
}
