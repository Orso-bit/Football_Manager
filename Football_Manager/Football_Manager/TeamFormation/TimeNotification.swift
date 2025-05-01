//
//  TimeNotification.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 01/05/25.
//

import UserNotifications
import SwiftUI

struct TimeNotification: View {
    @Binding var isShowingDatePicker: Bool
    @Binding var selectedDate: Date
    @Binding var selectedNumber: Int
    @Binding var selectedPlayersTeam1: [Player?]
    @Binding var selectedPlayersTeam2: [Player?]
    var numberPlayers: [Int]
    
    var body: some View {
        NavigationStack {
            Text("")
        }.navigationBarTitle("Number of Players")
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
                            
                            // Request notification permission
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("Permission granted")
                                    
                                    // Calculate one day before selected date
                                    let calendar = Calendar.current
                                    if let oneDayBefore = calendar.date(byAdding: .day, value: -1, to: selectedDate) {
                                        
                                        let content = UNMutableNotificationContent()
                                        content.title = "Event Reminder"
                                        content.body = "Your event is one day away!"
                                        content.sound = .default
                                        
                                        // Remove previous notifications
                                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                        
                                        if oneDayBefore > Date() {
                                            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: oneDayBefore)
                                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                            
                                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                            
                                            UNUserNotificationCenter.current().add(request) { error in
                                                if let error = error {
                                                    print("Error adding notification: \(error.localizedDescription)")
                                                } else {
                                                    print("Notification scheduled for \(oneDayBefore)")
                                                }
                                            }
                                        } else {
                                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                            
                                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                            
                                            UNUserNotificationCenter.current().add(request) { error in
                                                if let error = error {
                                                    print("Error adding immediate notification: \(error.localizedDescription)")
                                                } else {
                                                    print("Notification sent immediately")
                                                }
                                            }
                                        }
                                    }
                                    
                                } else if let error = error {
                                    print("Error requesting permission: \(error.localizedDescription)")
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
    }
}
