//
//  registerationController.swift
//  Messaging
//
//  Created by Abhishek P Mukundan on 09/04/2020.
//  Copyright © 2020 Abhishek P Mukundan. All rights reserved.
//
import Foundation
import UIKit
import Firebase


class RegisterationController: UIViewController {
    ///MARK: properties
    
    private var viewModel = RegisterationViewModel()
    weak var delegate: AuthenticationDelegate?

    private var profileImage: UIImage?
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.badge.plus.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainer: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "envelope"), textView: emailTextField)
        return containerView
    }()
    
    private lazy var fullNameContainer: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "person"), textView: fullNameTextField)
        return containerView
    }()
    
    private lazy var usernameContainer: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "person"), textView: userNameTextField)
        return containerView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        let containerView = InputContainerView(image: UIImage(systemName: "lock"), textView: passwordTextField)
        
        return containerView
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Email")
        return tf
    }()
    
    private let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Full Name")
        return tf
    }()
    
    private let userNameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Username")
        return tf
    }()
    
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Have an account? ", attributes:[.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes:[.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    
    ///MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    ///MARK: Helper
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer, fullNameContainer, usernameContainer, passwordContainerView, signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
    }
    
    //MARK: - Selector
    @objc func handleShowSignUp() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func configureNotificationObserver() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField{
            viewModel.password = sender.text
        }
        else if sender == userNameTextField{
            viewModel.username = sender.text
        }
        else if sender == fullNameTextField{
            viewModel.fullname = sender.text
        }
        checkFormStatus()
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleRegistration() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = RegisterationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        showLoader(true, withText: "Signing You Up")
        
        AuthService.shared.createUser(credential: credentials) { (error) in
            if let error = error {
                self.showError(error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

//MARK: - Image Picker
extension RegisterationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal) , for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200/2
        plusPhotoButton.layer.masksToBounds = true
        profileImage = image
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterationController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        }else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}
