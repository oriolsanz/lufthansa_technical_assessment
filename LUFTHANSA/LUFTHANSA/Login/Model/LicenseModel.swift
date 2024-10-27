//
//  LicenseModel.swift
//  LUFTHANSA
//
//  Created by Oriol Sanz Vericat on 27/10/24.
//

import Foundation

struct PilotLicenseRoot: Codable {
    let pilotLicenses: [PilotLicense]
    
    enum CodingKeys: String, CodingKey {
        case pilotLicenses = "pilot-licenses"
    }
}

struct PilotLicense: Codable {
    
    let type: String
    let aircrafts: [String]
}
