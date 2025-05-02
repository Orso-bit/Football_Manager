//
//  TimeNotification.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 01/05/25.
//

import UserNotifications
import SwiftUI

struct TimeNotification: View {
    @Binding var selectedDate: Date
    @Binding var isShowing: Bool
    
    var body: some View {
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
                isShowing = false
                scheduleNotification(for: selectedDate)
            }
            .padding()
        }
        .padding()
        .presentationDetents([.fraction(0.5), .medium])
    }
    
    private func scheduleNotification(for date: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard success else {
                if let error = error {
                    print("Permission error: \(error)")
                }
                return
            }

            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: selectedDate)

            let content = UNMutableNotificationContent()
            content.title = "Match Day!"
            content.body = "Today is your scheduled match."
            content.sound = .default

            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

            if startOfDay > Date() {
                let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startOfDay)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled for \(startOfDay)")
                    }
                }
            }
        }
    }
}
