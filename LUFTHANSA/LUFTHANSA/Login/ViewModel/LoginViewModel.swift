//
//  LoginViewModel.swift
//  LUFTHANSA
//
//  Created by Oriol Sanz Vericat on 27/10/24.
//

import Foundation
import Security

class LoginViewModel: ObservableObject {
    
    var pilot: PilotModel
    
    init() {
        pilot = PilotModel(name: "", licenseType: "", password: "")
    }
}

// MARK: - Fields validation
extension LoginViewModel {
    
    func isValidPilotName(name: String) -> Bool {
        return name.contains(" ")
    }
    
    func isValidPassword(password: String, name: String) -> Bool {
        let numberRegex = #"[0-9]+"#
        return password.count>11                                                // check if it has at least 12 characters
        && password.lowercased() != password                                    // check if it has uppercase characters
        && password.uppercased() != password                                    // check if it has lowercase characters
        && password.range(of: numberRegex, options: .regularExpression) != nil  // check if it has a number
        && !containsUserName(password: password, name: name)                    // check if it contains the user name
    }
    
    func containsUserName(password: String, name: String) -> Bool {
        let nameParts = name.split(separator: " ")
        
        for part in nameParts {
            if password.lowercased().contains(part.lowercased()) {
                return true
            }
        }
        
        return false
    }
    
    func isValidPasswordVerification(password: String, passwordVerification: String) -> Bool {
        return password == passwordVerification
    }
    
    func isValidLicenseSelected() -> Bool {
        return pilot.licenseType != ""
    }
}

// MARK: - Data treatment
extension LoginViewModel {
    
    func loadLicenses() -> [PilotLicense] {
        guard let path = Bundle.main.path(forResource: "licenses", ofType: "json") else {
            print("Error: JSON not found")
            return []
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let licenseRoot = try decoder.decode(PilotLicenseRoot.self, from: data)
            return licenseRoot.pilotLicenses
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
        return []
    }
    
    func setPilotName(name: String) {
        pilot.name = name
    }
    
    func setPilotLicense(license: String) {
        pilot.licenseType = license
    }
    
    func setPilotPassword(password: String) {
        pilot.password = password
    }
    
    func savePilot() {
        do {
            let encodedData = try JSONEncoder().encode(pilot)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: String(data: encodedData, encoding: .utf8) as Any,
                kSecValueData as String: encodedData
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                print("Pilot saved successfully")
            }
        } catch let error {
            print("Error saving the data: \(error)")
        }
    }
    
    func getPilot() -> PilotModel? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitAll,
                                    kSecReturnPersistentRef as String: kCFBooleanTrue as CFBoolean,
                                    kSecReturnData as String: kCFBooleanTrue as CFBoolean]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            guard let retrievedData = result as? [NSDictionary] else {
                return nil
            }
            
            for item in retrievedData {
                if let jsonData = item[kSecValueData] as? Data {
                    return try! JSONDecoder().decode(PilotModel.self, from: jsonData)
                }
            }
        } else {
            return nil
        }
        return nil
    }
    
    func deleteAllData() {
        _ = SecItemDelete([kSecClass as String: kSecClassGenericPassword] as CFDictionary)
    }
}

// MARK: - Login
extension LoginViewModel {
    
    func performLogin() {
        
        deleteAllData()
        savePilot()
    }
}
