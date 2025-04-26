//
//  TeamContentView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 26/04/25.
//

import SwiftData
import SwiftUI

struct TeamsContentView: View {
    @Query private var players: [Player]
    
    @State private var isShowingDatePicker = false
    @State private var selectedDate: Date = Date()
    @State private var selectedPlayersTeam1: [Player?] = Array(repeating: nil, count: 5)
    @State private var selectedPlayersTeam2: [Player?] = Array(repeating: nil, count: 5)
    
    @State private var selectedNumber = 5
    var numberPlayers = [5, 6, 8, 11]
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView {
                    VStack(spacing: 20) {
                        TeamSection(
                            title: "Team 1",
                            selectedPlayers: $selectedPlayersTeam1,
                            otherSelectedPlayers: $selectedPlayersTeam2,
                            selectedNumber: $selectedNumber,
                            allPlayers: players
                        )
                        
                        TeamSection(
                            title: "Team 2",
                            selectedPlayers: $selectedPlayersTeam2,
                            otherSelectedPlayers: $selectedPlayersTeam1,
                            selectedNumber: $selectedNumber,
                            allPlayers: players
                        )
                        
                        Button("Submit") {
                            if selectedPlayersTeam1.contains(where: { $0 == nil }) || selectedPlayersTeam2.contains(where: { $0 == nil }) {
                                print("Please select all players for both teams.")
                            } else {
                                print("Team 1: \(selectedPlayersTeam1.compactMap { $0?.name }.joined(separator: ", "))")
                                print("Team 2: \(selectedPlayersTeam2.compactMap { $0?.name }.joined(separator: ", "))")
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(numberPlayers, id: \.self) { number in
                            Button("\(number)") {
                                selectedNumber = number
                                selectedPlayersTeam1 = Array(repeating: nil, count: number)
                                selectedPlayersTeam2 = Array(repeating: nil, count: number)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingDatePicker = true
                    }) {
                        Image(systemName: "calendar.badge.clock")
                    }
                    .sheet(isPresented: $isShowingDatePicker) {
                        VStack(spacing: 20) {
                            Text("Select Date and Time")
                                .font(.headline)
                                .padding(.top)

                            DatePicker(
                                "",
                                selection: $selectedDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()

                            Button("Done") {
                                isShowingDatePicker = false
                            }
                            .padding()
                        }
                        .padding()
                        .presentationDetents([.fraction(0.5), .medium]) // 👈 Qui controlli l'altezza!
                    }
                }
            }
        }
    }
}
