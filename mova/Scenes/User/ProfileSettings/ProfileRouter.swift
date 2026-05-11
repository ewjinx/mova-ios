//
//  ProfileRouter.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 7/5/2026.
//
import UIKit
import Foundation

protocol ProfileRoutingLogic {
    func routeToEditProfile()
}

class ProfileRouter: NSObject, ProfileRoutingLogic {
    weak var viewController: UIViewController?

    func routeToEditProfile() {
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        guard let editProfileVC = storyboard.instantiateViewController(withIdentifier: "EditProfile") as? EditProfileViewController else { return }

        if let profileViewController = viewController as? ProfileViewController,
           let profileViewModel = profileViewController.currentViewModel {
            editProfileVC.configure(with: profileViewModel)
        }

        viewController?.navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
