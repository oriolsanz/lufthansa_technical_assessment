//
//  ConfirmationViewModelTests.swift
//  ConfirmationViewModelTests
//
//  Created by Oriol Sanz Vericat on 27/10/24.
//

import XCTest
@testable import LUFTHANSA

final class ConfirmationViewModelTests: XCTestCase {

    func testGetAllowedAircraftFor() {
        let viewModel = ConfirmationViewModel()

        // Test with a valid license
        let allowedAircraft = viewModel.getAllowedAircraftFor(license: "PPL")
        XCTAssertNotEqual(allowedAircraft, "")

        // Test with an invalid license
        let invalidAircraft = viewModel.getAllowedAircraftFor(license: "InvalidLicense")
        XCTAssertEqual(invalidAircraft, "")
    }

    func testDeleteAllData() {
        // TODO: Implement a test to verify Keychain deletion
        // Might need to mock the Keychain API or use a test environment.
        // Consider using a third-party library like KeychainAccess to simplify testing.
    }
}
