//
//  ConfirmationView.swift
//  LUFTHANSA
//
//  Created by Oriol Sanz Vericat on 27/10/24.
//

import UIKit

class ConfirmationView: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var licenseTypeLabel: UILabel!
    @IBOutlet weak var allowedAircraftListLabel: UILabel!
    
    private var viewModel = ConfirmationViewModel()
    
    var pilot: PilotModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        
        welcomeLabel.text = "Welcome \(pilot?.name ?? "")"
        licenseTypeLabel.text = "License Type: \(pilot?.licenseType ?? "")"
        allowedAircraftListLabel.text = viewModel.getAllowedAircraftFor(license: pilot?.licenseType ?? "")
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        viewModel.deleteAllData()
        dismiss(animated: true)
    }
}
