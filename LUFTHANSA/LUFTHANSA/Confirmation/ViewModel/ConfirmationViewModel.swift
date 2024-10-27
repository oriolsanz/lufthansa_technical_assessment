//
//  ConfirmationViewModel.swift
//  LUFTHANSA
//
//  Created by Oriol Sanz Vericat on 27/10/24.
//

import Foundation

class ConfirmationViewModel: ObservableObject {
    
    func getAllowedAircraftFor(license: String) -> String {
        
        guard let path = Bundle.main.path(forResource: "licenses", ofType: "json") else {
            print("Error: JSON not found")
            return ""
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let licenseRoot = try decoder.decode(PilotLicenseRoot.self, from: data)
            for lic in licenseRoot.pilotLicenses {
                if lic.type == license {
                    var aircrafts = ""
                    for aircraft in lic.aircrafts {
                        if lic.aircrafts.first != aircraft {
                            aircrafts = aircrafts + ", "
                        }
                        aircrafts = aircrafts + aircraft
                    }
                    return aircrafts
                }
            }
        } catch let DecodingError.dataCorrupted(context) {
            print(context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)

        } catch let DecodingError.valueNotFound(type,
     context) {
            print("Value of type \(type) expected:", context.debugDescription)
        } catch let error {
            print(error)
        }
        return ""
    }
    
    func deleteAllData() {
        let status = SecItemDelete([kSecClass as String: kSecClassGenericPassword] as CFDictionary)
        guard status == errSecSuccess else {
            print("Error deleting data: \(status)")
            return
        }
    }
}
