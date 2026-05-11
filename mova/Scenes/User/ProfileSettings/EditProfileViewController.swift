//
//  EditProfileViewController.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 7/5/2026.
//

import Foundation
import UIKit

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    

    @IBOutlet var fullNameField: UITextField!
    @IBOutlet var profilePicture: UIImageView!
    
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var firstNameField: UITextField!
    private var viewModel: EditProfile.ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInfo()
    }

    func configure(with profileViewModel: ProfileSettings.Fetch.ViewModel) {
        viewModel = EditProfile.ViewModel(profileViewModel: profileViewModel)
    }
    
    func setupInfo()
    {
        profilePicture.image = viewModel?.profileImage
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2;
        fullNameField.text = viewModel?.name
        firstNameField.text = viewModel?.name.split(separator: " ").first.map(String.init)
        emailField.text = viewModel?.email
        
        fullNameField.textColor = .movaLabel
        firstNameField.textColor = .movaLabel
        emailField.textColor = .movaLabel
        
        editButton.imageView?.contentMode = .scaleAspectFit
        
        
    }
    
    
    
    
    @IBAction func updatePressed(_ sender: Any) {
        
        UserDefaults.standard.set(fullNameField.text, forKey: "user_name")
        UserDefaults.standard.set(emailField.text, forKey: "user_email")
        
        if let image = profilePicture.image {
            let imageData = image.jpegData(compressionQuality: 0.8)
            UserDefaults.standard.set(imageData, forKey: "user_profile_image")
        }
        
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName) //documents/img.jpeg

        if let jpegData = image.jpegData(compressionQuality: 0.8) {     //converting UIImage to data
            try? jpegData.write(to: imagePath)      //writing data object to path
        }
        
        
        profilePicture.image = squareCroppedImage(from: image)
       

        dismiss(animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    private func squareCroppedImage(from image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let side = min(width, height)
        
        let x = (width - side) / 2
        let y = (height - side) / 2
        
        let cropRect = CGRect(x: x, y: y, width: side, height: side)
        guard let cropped = cgImage.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cropped, scale: image.scale, orientation: image.imageOrientation)
        
    }
    
}

