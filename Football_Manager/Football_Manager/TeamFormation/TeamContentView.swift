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
                        Button {
                            let (balancedTeam1, balancedTeam2) = createRandomBalancedTeams(from: players, teamSize: selectedNumber)

                            selectedPlayersTeam1 = balancedTeam1.map { Optional($0) }
                            selectedPlayersTeam2 = balancedTeam2.map { Optional($0) }

                        } label: {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.7))
                                
                                Text("Team Balance")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.blue)
                            }
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
    
    func createRandomBalancedTeams(from players: [Player], teamSize: Int) -> ([Player], [Player]) {
        guard players.count >= teamSize * 2 else {
            fatalError("Not enough players to form balanced teams.")
        }

        // Shuffle players first to introduce randomness
        let shuffledPlayers = players.shuffled()
        
        var bestTeam1: [Player] = []
        var bestTeam2: [Player] = []
        var minDifference = Int.max

        func backtrack(index: Int, team1: [Player], team2: [Player], score1: Int, score2: Int) {
            if team1.count == teamSize, team2.count == teamSize {
                let difference = abs(score1 - score2)
                if difference < minDifference {
                    minDifference = difference
                    bestTeam1 = team1
                    bestTeam2 = team2
                }
                return
            }

            if index >= shuffledPlayers.count { return }

            let player = shuffledPlayers[index]

            if team1.count < teamSize {
                backtrack(index: index + 1, team1: team1 + [player], team2: team2, score1: score1 + player.totalScore, score2: score2)
            }

            if team2.count < teamSize {
                backtrack(index: index + 1, team1: team1, team2: team2 + [player], score1: score1, score2: score2 + player.totalScore)
            }
        }

        backtrack(index: 0, team1: [], team2: [], score1: 0, score2: 0)

        print("Final Team Scores -> Team 1: \(bestTeam1.map(\.totalScore).reduce(0, +)), Team 2: \(bestTeam2.map(\.totalScore).reduce(0, +))")

        return (bestTeam1, bestTeam2)
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
