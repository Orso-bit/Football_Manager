//
//  ContentView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 18/04/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var players: [Player]
    @State private var showAddPlayer = false
    @State private var selectedRole: String = "All" // Il ruolo selezionato, inizialmente "All"

    let roles = ["All", "Goalkeeper", "Defender", "Midfielder", "Forward"]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Players")) {
                        ForEach(filteredPlayers) { player in
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
                                        .foregroundStyle(.gray)
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
                        .onDelete(perform: deletePlayers)
                    }
                }
            }
            .navigationTitle("Players")
            .toolbar {
                // Filtro per ruolo tramite Menu nella toolbar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("All") {
                            selectedRole = "All"
                        }
                        Button("Goalkeeper") {
                            selectedRole = "Goalkeeper"
                        }
                        Button("Defender") {
                            selectedRole = "Defender"
                        }
                        Button("Midfielder") {
                            selectedRole = "Midfielder"
                        }
                        Button("Forward") {
                            selectedRole = "Forward"
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle") // Icona filtro
                    }
                }

                // Pulsante per aggiungere un nuovo giocatore
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddPlayer.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }

                // Pulsante per abilitare la modalità di eliminazione
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddPlayer) {
                AddPlayerView()
            }
        }
    }

    private func deletePlayers(at offsets: IndexSet) {
        for index in offsets {
            let player = filteredPlayers[index]
            modelContext.delete(player)
        }
    }

    // Computed property per filtrare i giocatori in base al ruolo selezionato
    var filteredPlayers: [Player] {
        if selectedRole == "All" {
            return players
        } else {
            return players.filter { $0.role == selectedRole }
        }
    }
}

#Preview {
    ContentView()
}
