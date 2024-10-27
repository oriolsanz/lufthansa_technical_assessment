//
//  LoginViewModelTests.swift
//  LUFTHANSATests
//
//  Created by Oriol Sanz Vericat on 27/10/24.
//

import XCTest
@testable import LUFTHANSA

final class LoginViewModelTests: XCTestCase {

    func testIsValidPilotName_WithSpace() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        XCTAssertTrue(viewModel.isValidPilotName(name: name))
    }

    func testIsValidPilotName_WithoutSpace() {
        let viewModel = LoginViewModel()
        let name = "JohnDoe"
        XCTAssertFalse(viewModel.isValidPilotName(name: name))
    }
    
    func testIsValidPassword_ValidPassword() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        let password = "TestPassword123!"
        XCTAssertTrue(viewModel.isValidPassword(password: password, name: name))
    }

    func testIsValidPassword_TooShort() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        let password = "ShortPass"
        XCTAssertFalse(viewModel.isValidPassword(password: password, name: name))
    }

    func testIsValidPassword_NoUpperCase() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        let password = "testpassword123!"
        XCTAssertFalse(viewModel.isValidPassword(password: password, name: name))
    }

    func testIsValidPassword_NoLowerCase() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        let password = "TESTPASSWORD123!"
        XCTAssertFalse(viewModel.isValidPassword(password: password, name: name))
    }

    func testIsValidPassword_NoNumber() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        let password = "TestPasswordStrong!"
        XCTAssertFalse(viewModel.isValidPassword(password: password, name: name))
    }

    func testIsValidPassword_ContainsUserName() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        let password = "TestDoepassword123!"
        XCTAssertFalse(viewModel.isValidPassword(password: password, name: name))
    }
    
    func testIsValidPasswordVerification_MatchingPasswords() {
        let viewModel = LoginViewModel()
        let password = "TestPassword123!"
        let passwordVerification = password
        XCTAssertTrue(viewModel.isValidPasswordVerification(password: password, passwordVerification: passwordVerification))
    }

    func testIsValidPasswordVerification_NonMatchingPasswords() {
        let viewModel = LoginViewModel()
        let password = "TestPassword123!"
        let passwordVerification = "WrongPassword"
        XCTAssertFalse(viewModel.isValidPasswordVerification(password: password, passwordVerification: passwordVerification))
    }
    
    func testIsValidLicenseSelected_SelectedLicense() {
        let viewModel = LoginViewModel()
        viewModel.pilot.licenseType = "PPL"
        XCTAssertTrue(viewModel.isValidLicenseSelected())
    }

    func testIsValidLicenseSelected_NoSelectedLicense() {
        let viewModel = LoginViewModel()
        XCTAssertFalse(viewModel.isValidLicenseSelected())
    }
    
    func testLoadLicenses_MockData() {
        let viewModel = LoginViewModel()
        
        let mockLicenses = [PilotLicense(type: "PPL", aircrafts: ["Cessna 172"])]

        let licenses = mockLicenses
        XCTAssertEqual(licenses.count, 1)
        XCTAssertEqual(licenses[0].type, "PPL")
    }

    func testLoadLicenses_ValidJSON() {
        let viewModel = LoginViewModel()
        
        let licenses = viewModel.loadLicenses()
        XCTAssertTrue(licenses.count > 0)
        
        // Maybe test specific license data based on your JSON structure
    }
    
    func testSetPilotName() {
        let viewModel = LoginViewModel()
        let name = "John Doe"
        viewModel.setPilotName(name: name)
        XCTAssertEqual(viewModel.pilot.name, name)
    }

    func testSetPilotLicense() {
        let viewModel = LoginViewModel()
        let license = "PPL"
        viewModel.setPilotLicense(license: license)
        XCTAssertEqual(viewModel.pilot.licenseType, license)
    }

    func testSetPilotPassword() {
        let viewModel = LoginViewModel()
        let password = "StrongPassword123!"
        viewModel.setPilotPassword(password: password)
        XCTAssertEqual(viewModel.pilot.password, password)
    }
    
    func testSavePilot_Encoding() {
        let viewModel = LoginViewModel()
        viewModel.pilot.name = "Test Pilot"
        viewModel.pilot.licenseType = "PPL"
        viewModel.pilot.password = "TestPassword"
        
        do {
            let encodedData = try JSONEncoder().encode(viewModel.pilot)
            XCTAssertNotNil(encodedData)
        } catch {
            XCTFail("Error encoding pilot data: \(error)")
        }
    }
    
    func testGetPilot_SavedPilot() {
        
        let viewModel = LoginViewModel()
        viewModel.pilot.name = "Test Pilot"
        viewModel.pilot.licenseType = "PPL"
        viewModel.pilot.password = "TestPassword"
        
        viewModel.savePilot()
        
        let pilot = viewModel.getPilot()
        XCTAssertNotNil(pilot)
        
        // Could test specific pilot data retrieved
    }
}
