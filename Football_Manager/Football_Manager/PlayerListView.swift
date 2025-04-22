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
                    NavigationLink(destination: PlayerCardView(player: player)) {
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
            }
        }
    }
}
