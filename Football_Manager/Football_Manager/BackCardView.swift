//
//  BackCardView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 22/04/25.
//

import SwiftUI

struct BackCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 350, height: 400)
                .shadow(radius: 10)
            HStack {
                VStack {
                    Text("Goals")
                    // Text("\(player.goals)")
                    Text("Presence")
                }
                Spacer().frame(width: 100)
                VStack {
                    Text("Assists")
                    // Text("\(player.assists)")
                    Text("Woodwork")
                }
            }
            .font(.system(size: 18))
            .bold()
        }
    }
}

#Preview {
    BackCardView()
}
