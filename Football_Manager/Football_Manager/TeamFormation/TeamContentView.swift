//
//  TeamContentView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 26/04/25.
//

import UserNotifications
import SwiftData
import SwiftUI

struct TeamsContentView: View {
    @Query private var players: [Player]
    
    @State private var isShowingDatePicker = false
    @State private var selectedDate: Date = Date()
    @State private var selectedPlayersTeam1: [Player?] = Array(repeating: nil, count: 5)
    @State private var selectedPlayersTeam2: [Player?] = Array(repeating: nil, count: 5)
    
    @State private var isShowingAlert: Bool = false
    
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
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Choose the date and time of the match")
                            .font(.headline)
                        
                        
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
                    }
                    .padding()
                        Button("Submit") {
                            if selectedPlayersTeam1.contains(where: { $0 == nil }) || selectedPlayersTeam2.contains(where: { $0 == nil }) {
                                print("Please select all players for both teams.")
                                isShowingAlert = true
                            } else {
                                let team1TotalScore: Int = selectedPlayersTeam1.compactMap(\.?.totalScore).reduce(0, +)
                                let team2TotalScore: Int = selectedPlayersTeam2.compactMap(\.?.totalScore).reduce(0, +)
                                
                                let difference = abs(team1TotalScore - team2TotalScore)
                                
                                print("Team 1 Total Score: \(team1TotalScore)")
                                print("Team 2 Total Score: \(team2TotalScore)")
                                print("Score Difference: \(difference)")
                                
                                if difference <= 5 {
                                    print("Teams are balanced")
                                } else {
                                    print("Team are not balanced")
                                }
                            }
                        }.alert(isPresented: $isShowingAlert) {
                            Alert(title: Text("Please complete all required fields."), message: Text("Remeber to select the Date"), dismissButton: .default(Text("OK")))
                        }
                        .padding()
                }
                
            }
            TimeNotification(
                isShowingDatePicker: $isShowingDatePicker,
                selectedDate: $selectedDate,
                selectedNumber: $selectedNumber,
                selectedPlayersTeam1: $selectedPlayersTeam1,
                selectedPlayersTeam2: $selectedPlayersTeam2,
                numberPlayers: numberPlayers
            )
            
            .navigationTitle("Select the Players")
        }
    }
}
