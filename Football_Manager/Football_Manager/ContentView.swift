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
    @State private var selectedRole: String = "All"
    
    let roles = ["All", "Goalkeeper", "Defender", "Midfielder", "Forward"]
    
    var body: some View {
        TabView {
            NavigationView {
                PlayerListView(players: players, filteredPlayers: filteredPlayers, deletePlayers: deletePlayers)
                    .navigationTitle("Players")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                ForEach(roles, id: \.self) { role in
                                    Button(role) {
                                        selectedRole = role
                                    }
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showAddPlayer.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                        }
                    }
                    .sheet(isPresented: $showAddPlayer) {
                        AddPlayerView()
                    }
            }
            .tabItem {
                Label("Players", systemImage: "list.dash")
            }
            
            NavigationStack {
                MatchManagementView()
            }
            .tabItem {
                Label("Match", systemImage: "soccerball.inverse")
            }
        }
    }
    
    private func deletePlayers(at offsets: IndexSet) {
        for index in offsets {
            let player = filteredPlayers[index]
            modelContext.delete(player)
        }
    }
    
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
        .modelContainer(for: Player.self, inMemory: true)
}
