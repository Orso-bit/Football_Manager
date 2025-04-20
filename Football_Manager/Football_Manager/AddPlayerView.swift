//
//  AddPlayerView.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 18/04/25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct AddPlayerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var viewModel = ProfileViewModel()
    
    @State private var name = ""
    @State private var surname = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var preferredFoot = ""
    @State private var agility = ""
    @State private var endurance = ""
    @State private var speed = ""
    @State private var strength = ""
    @State private var verticalJump = ""
    @State private var profileImage: UIImage?
    @State private var role = ""
    
    let foot = ["Left", "Right", "Both"]
    
    let roles = ["Goalkeeper", "Defender", "Midfielder", "Forward"]
    
    let pickerOptions = ["Low", "Medium", "High"]
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    PhotosPicker(selection: $viewModel.selectedImage) { // <-- profile image
                        if let profileImage = viewModel.profileImage {
                            profileImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(Color(.systemGray4))
                        }
                    }
                    
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                        .offset(x: -5, y: -5)
                }
                .frame(width: 80, height: 80)
                .padding()
                Form {
                    
                    Section(header: Text("Personal Info")) {
                        TextField("Name", text: $name)
                        TextField("Surname", text: $surname)
                        TextField("Weight (kg)", text: $weight)
                        TextField("Height (cm)", text: $height)
                    }
                    
                    Section(header: Text("Attributes")) {
                        Picker("Foot", selection: $preferredFoot) {
                            ForEach(foot, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Agility", selection: $agility) {
                            ForEach(pickerOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Endurance", selection: $endurance) {
                            ForEach(pickerOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Speed", selection: $speed) {
                            ForEach(pickerOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Strength", selection: $strength) {
                            ForEach(pickerOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Vertical Jump", selection: $verticalJump) {
                            ForEach(pickerOptions, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    Section(header: Text("Role")) {
                        Picker("Role", selection: $role) {
                            ForEach(roles, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
                .navigationTitle("Add New Player")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if let finalImage = viewModel.uiImage {
                                let newPlayer = Player(
                                    name: name,
                                    surname: surname,
                                    weight: Double(weight) ?? 0,
                                    height: Double(height) ?? 0,
                                    preferredFoot: preferredFoot,
                                    agility: agility,
                                    endurance: endurance,
                                    speed: speed,
                                    strength: strength,
                                    verticalJump: verticalJump,
                                    role: role,
                                    profileImage: finalImage.jpegData(compressionQuality: 0.8)
                                )
                                modelContext.insert(newPlayer)
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}
