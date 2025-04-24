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
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [Player]
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
                
                Section(header: Text("Where")) {
                    HStack {
                        Image(systemName: "map")
                            .font(.title2)
                        TextField("Address", text: $address)
                    }
                    .padding(.vertical, 8)
                }
                Section(header: Text("Team 1")) {
                    ForEach(0..<5, id: \.self) { index in
                        Picker("Player \(index + 1)", selection: $selectedPlayerIds1[index]) {
                            ForEach(players) { player in
                                Text(player.name)
                                    .tag(player.id)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                Section(header: Text("Team 2")) {
                    ForEach(0..<5, id: \.self) { index in
                        Picker("Player \(index + 1)", selection: $selectedPlayerIds2[index]) {
                            ForEach(players) { player in
                                Text(player.name)
                                    .tag(player.id)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
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
