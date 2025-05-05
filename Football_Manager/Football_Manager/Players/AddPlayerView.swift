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
    @State private var role = ""
    
    @State private var showAlert = false

    // Opzioni per i picker
    let foot = ["Left", "Right", "Both"]
    let roles = ["Goalkeeper", "Defender", "Midfielder", "Forward"]
    let pickerOptions = ["Low", "Medium", "High"]

    var body: some View {
        NavigationView {
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

                VStack {
                    // Picker per l'immagine profilo
                    ZStack(alignment: .bottomTrailing) {
                        PhotosPicker(selection: $viewModel.selectedImage) {
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
                                    .foregroundStyle(Color(red: 225/255, green: 238/255, blue: 188/255))
                            }
                        }
                        
                        // Icona "+" per cambiare immagine
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .background(Circle().fill(Color.white))
                            .offset(x: -5, y: -5)
                    }
                    .frame(width: 80, height: 80)
                    .padding()

                    // Form principale
                    Form {
                        // Sezione dati personali
                        Section(header: Text("Personal Info")) {
                            CustomTextField(placeholder: "Name", text: $name)
                            CustomTextField(placeholder: "Surname", text: $surname)
                            CustomTextField(placeholder: "Weight (kg)", text: $weight)
                            CustomTextField(placeholder: "Height (cm)", text: $height)
                        }
                        .listRowBackground(Color(red: 225/255, green: 238/255, blue: 188/255))
                        
                        // Sezione attributi
                        Section(header: Text("Attributes")) {
                            AttributeMenu(title: "Preferred Foot", selection: $preferredFoot, options: foot, systemImage: "figure.walk")
                            AttributeMenu(title: "Agility", selection: $agility, options: pickerOptions, systemImage: "bolt")
                            AttributeMenu(title: "Endurance", selection: $endurance, options: pickerOptions, systemImage: "heart")
                            AttributeMenu(title: "Speed", selection: $speed, options: pickerOptions, systemImage: "hare")
                            AttributeMenu(title: "Strength", selection: $strength, options: pickerOptions, systemImage: "dumbbell")
                            AttributeMenu(title: "Vertical Jump", selection: $verticalJump, options: pickerOptions, systemImage: "arrow.up")
                        }
                        .listRowBackground(Color(red: 225/255, green: 238/255, blue: 188/255))
                        
                        // Sezione ruolo
                        Section(header: Text("Role")) {
                            AttributeMenu(title: "Role", selection: $role, options: roles, systemImage: "person.3")
                        }
                        .listRowBackground(Color(red: 225/255, green: 238/255, blue: 188/255))
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Add New Player")
                    .toolbar {
                        // Bottone "Cancel" a sinistra
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                        // Bottone "Save" a destra
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                if name.isEmpty || surname.isEmpty || weight.isEmpty || height.isEmpty || role.isEmpty || preferredFoot.isEmpty || agility.isEmpty || endurance.isEmpty || speed.isEmpty || strength.isEmpty || verticalJump.isEmpty {
                                    showAlert = true
                                    print("Please complete all required fields.")
                                } else if let finalImage = viewModel.uiImage {
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
                                    modelContext.insert(newPlayer)   // Salva nuovo giocatore
                                    dismiss()   // Chiude la view
                                }
                            }.alert("Please fill in all mandatory fields.", isPresented: $showAlert) {
                                Button("OK", role: .cancel) { }
                            }
                        }
                    }
                }
            }
        }
    }
}

// Campo di testo personalizzato con placeholder
private struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
            }
            TextField("", text: $text)
                .foregroundColor(.primary)
        }
    }
}

// Menu a tendina personalizzato per scegliere attributi
private struct AttributeMenu: View {
    var title: String
    var selection: Binding<String>
    var options: [String]
    var systemImage: String

    var body: some View {
        Menu {
            // Picker interno al Menu
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
        } label: {
            HStack {
                Label(title, systemImage: systemImage)   // Icona + titolo a sinistra
                Spacer()
                Text(selection.wrappedValue.isEmpty ? "Select" : selection.wrappedValue)   // Testo selezionato a destra
                    .foregroundColor(selection.wrappedValue.isEmpty ? .gray : .primary)
            }
        }
    }
}
