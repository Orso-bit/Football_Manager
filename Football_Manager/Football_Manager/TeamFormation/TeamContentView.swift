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
                                
                                // Chiedi permesso notifiche
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        print("Autorizzazione concessa")
                                        
                                        // Calcola un giorno prima della data selezionata
                                        let calendar = Calendar.current
                                        if let oneDayBefore = calendar.date(byAdding: .day, value: -1, to: selectedDate) {
                                            
                                            // ✅ Prima di tutto, creo il contenuto della nuova notifica
                                            let content = UNMutableNotificationContent()
                                            content.title = "Promemoria Evento"
                                            content.body = "Manca un giorno al tuo evento!"
                                            content.sound = .default
                                            
                                            // ✅ Rimuovo tutte le notifiche già programmate
                                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                            
                                            if oneDayBefore > Date() {
                                                // Caso normale: il giorno prima è nel futuro
                                                let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: oneDayBefore)
                                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                                
                                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                                
                                                UNUserNotificationCenter.current().add(request) { error in
                                                    if let error = error {
                                                        print("Errore nell'aggiungere la notifica: \(error.localizedDescription)")
                                                    } else {
                                                        print("Notifica programmata per \(oneDayBefore)")
                                                    }
                                                }
                                            } else {
                                                // Caso speciale: il giorno prima è già passato, invio la notifica subito
                                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // dopo 5 secondi
                                                
                                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                                
                                                UNUserNotificationCenter.current().add(request) { error in
                                                    if let error = error {
                                                        print("Errore nell'aggiungere la notifica immediata: \(error.localizedDescription)")
                                                    } else {
                                                        print("Giorno prima già passato: notifica inviata subito")
                                                    }
                                                }
                                            }
                                        }
                                        
                                    } else if let error = error {
                                        print("Errore richiesta autorizzazione: \(error.localizedDescription)")
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .presentationDetents([.fraction(0.5), .medium])
                    }
                }
            }
            .navigationTitle("Select the Players")
        }
    }
}
