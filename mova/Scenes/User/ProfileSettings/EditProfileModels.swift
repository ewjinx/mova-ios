//
//  EditProfileModels.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 7/5/2026.
//

import Foundation
import UIKit

enum EditProfile {
    enum LoadProfile {
        struct Request {}

        struct Response {
            let name: String
            let email: String
            let profileImage: UIImage?
        }

        struct ViewModel {
            let name: String
            let email: String
            let profileImage: UIImage?
        }
    }

    struct ViewModel {
        let name: String
        let email: String
        let profileImage: UIImage?

        init(name: String, email: String, profileImage: UIImage?) {
            self.name = name
            self.email = email
            self.profileImage = profileImage
        }

        init(profileViewModel: ProfileSettings.Fetch.ViewModel) {
            self.name = profileViewModel.name
            self.email = profileViewModel.email
            self.profileImage = profileViewModel.profileImage
        }
    }
}
