//
//  Player.swift
//  Football_Manager
//
//  Created by Giovanni Jr Di Fenza on 18/04/25.
//

import SwiftData
import SwiftUI

@Model
class Player {
    var id: UUID
    var name: String
    var surname: String
    var weight: Double
    var height: Double
    var preferredFoot: String
    var agility: String
    var endurance: String
    var speed: String
    var strength: String
    var verticalJump: String
    var role: String // 👈 Aggiunta del ruolo
    var profileImage: Data?

    init(name: String, surname: String, weight: Double, height: Double, preferredFoot: String, agility: String, endurance: String, speed: String, strength: String, verticalJump: String, role: String, profileImage: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.surname = surname
        self.weight = weight
        self.height = height
        self.preferredFoot = preferredFoot
        self.agility = agility
        self.endurance = endurance
        self.speed = speed
        self.strength = strength
        self.verticalJump = verticalJump
        self.role = role // 👈
        self.profileImage = profileImage
    }
}
