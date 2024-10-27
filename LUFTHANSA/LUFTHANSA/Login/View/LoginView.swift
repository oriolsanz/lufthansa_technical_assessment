//
//  LoginView.swift
//  LUFTHANSA
//
//  Created by Oriol Sanz Vericat on 27/10/24.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var licenseTypeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private lazy var menu = UIMenu(title: "License Type", children: menuElements)
    private var menuElements: [UIAction] = []
    
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMenuButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let pilot = viewModel.getPilot() {
            goToConfirmationView(pilot: pilot)
        }
    }
    
    private func configureMenuButton() {
        
        for license in viewModel.loadLicenses() {
            menuElements.append(UIAction(title: license.type) { action in
                self.licenseTypeButton.setTitle("License: \(license.type)", for: .normal)
                self.viewModel.setPilotLicense(license: license.type)
            })
        }
        
        licenseTypeButton.menu = menu
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        errorLabel.text = ""
        let name = nameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let passwordVerification = passwordVerificationTextField.text ?? ""
        
        // HARDCODE
        //let name = "oriol sas"
        //let password = "Asdasdasdasd123"
        //let passwordVerification = "Asdasdasdasd123"
        // HARDCODE END
        
        if !viewModel.isValidPilotName(name: name) {
            errorLabel.text = "Name should have at least a space"
        }
        
        if !viewModel.isValidLicenseSelected() {
            errorLabel.text = "You should select a license type"
        }
        
        if !viewModel.isValidPasswordVerification(password: password, passwordVerification: passwordVerification) {
            errorLabel.text = "The two passwords should be the same"
        }
        
        if !viewModel.isValidPassword(password: password, name: name) {
            errorLabel.text = "Invalid password, should contain an uppercase, a lowercase, a number, have at least 12 characters and not contain the user name"
        }
        
        if let error = errorLabel.text, error.isEmpty {
            viewModel.setPilotName(name: name)
            viewModel.setPilotPassword(password: password)
            viewModel.performLogin()
            goToConfirmationView(pilot: viewModel.pilot)
        }
    }
    
    func goToConfirmationView(pilot: PilotModel) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "idConfirmationView") as? ConfirmationView {
            vc.pilot = pilot
            self.present(vc, animated: true)
        }
    }
}

