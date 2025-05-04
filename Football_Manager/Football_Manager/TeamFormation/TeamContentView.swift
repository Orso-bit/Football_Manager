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
    
    @State private var activeAlert: alertType?
    
    @State private var selectedNumber = 5
    var numberPlayers = [5, 6, 8, 11]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 144/255, green: 198/255, blue: 124/255),
                        Color(red: 103/255, green: 174/255, blue: 110/255)
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
                        
                        Button {
                            if selectedPlayersTeam1.contains(where: { $0 == nil }) || selectedPlayersTeam2.contains(where: { $0 == nil }) {
                                activeAlert = .missingPlayers
                            } else {
                                let team1TotalScore: Int = selectedPlayersTeam1.compactMap(\.?.totalScore).reduce(0, +)
                                let team2TotalScore: Int = selectedPlayersTeam2.compactMap(\.?.totalScore).reduce(0, +)
                                
                                let difference = abs(team1TotalScore - team2TotalScore)
                                
                                if difference <= 5 {
                                    activeAlert = .balanced
                                } else {
                                    activeAlert = .unbalanced
                                }
                            }
                        } label: {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .buttonBorderShape(.automatic)
                        .alert(item: $activeAlert) { alertType in
                            Alert(
                                title: Text("\(alertType.title)"),
                                message: Text("\(alertType.message)"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Match Configuration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
                        TimeNotification(
                            selectedDate: $selectedDate,
                            isShowing: $isShowingDatePicker
                        )
                    }
                }
            }
        }
    }
    
    enum alertType: Identifiable {
        case missingPlayers, balanced, unbalanced
        
        var id: Int { hashValue }
        
        var title: String {
            switch self {
            case .missingPlayers: return "Please complete all required fields."
            case .balanced: return "Teams are balanced"
            case .unbalanced: return "Teams are not balanced"
            }
        }
        
        var message: String {
            switch self {
            case .missingPlayers: return "Select all players for both teams and set the date."
            case .balanced: return "Ready to play!"
            case .unbalanced: return "Try changing some players."
            }
        }
    }
}

