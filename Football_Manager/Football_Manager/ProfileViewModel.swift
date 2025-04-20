//
//  ProfileViewModel.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 20/04/25.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI
import SwiftUICore

class ProfileViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    @Published var profileImage: Image?
    @Published var uiImage: UIImage?
    
    private func loadImage() async throws {
        guard let item = selectedImage else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        
        await MainActor.run {
            self.uiImage = uiImage // <-- SALVA QUI
            self.profileImage = Image(uiImage: uiImage)
        }
    }
}
