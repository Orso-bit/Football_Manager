//
//  MatchManagementView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 22/04/25.
//

import SwiftUI
import SwiftData

struct MatchManagementView: View {
    @State private var address = ""
    @State private var date = Date.now
    @Query private var players: [Player]
    @State private var searchText = ""
    @State private var filteredPlayers: [Player] = []
    @State private var selectedPlayerIds1: [UUID?] = Array(repeating: nil, count: 5)
    @State private var selectedPlayerIds2: [UUID?] = Array(repeating: nil, count: 5)
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 144/255, green: 198/255, blue: 124/255),
                    Color(red: 225/255, green: 238/255, blue: 188/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                List {
                    Section(header: Text("When")) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.title2)
                            DatePicker("Date", selection: $date, displayedComponents: .date)
                                .font(.title2)
                                .labelsHidden()
                            DatePicker("Time", selection: $date, displayedComponents:
                                    .hourAndMinute)
                            .font(.title2)
                            .labelsHidden()
                        }
                        .padding(.vertical, 3)
                    }
                    .listRowBackground(Color.white.opacity(0.9))
                    
                    Section(header: Text("Where")) {
                        HStack {
                            Image(systemName: "map")
                                .font(.title2)
                            TextField("Address", text: $address)
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.white.opacity(0.9))
                    Section (header: Text("Who")) {
                        TeamsContentView()
                    }
                }
                
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Match Day")
        }
    }
}

#Preview {
    NavigationStack {
        MatchManagementView()
            .modelContainer(for: Player.self, inMemory: true)
    }
}
