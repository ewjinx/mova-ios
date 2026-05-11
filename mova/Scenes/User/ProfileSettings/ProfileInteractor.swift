import UIKit
import Foundation



protocol ProfileBusinessLogic {
    func fetchProfile(request: ProfileSettings.Fetch.Request) async
}

class ProfileInteractor: ProfileBusinessLogic{
    
    
    var presenter: ProfilePresentationLogic?
    
    var userName: String = ""
    var userEmail: String = "andrew_ainsley@yourdomain.com"

    func fetchProfile(request: ProfileSettings.Fetch.Request) async {

        let savedName = UserDefaults.standard.string(forKey: "user_name") ?? "Andrew Ainsley"
        let savedEmail = UserDefaults.standard.string(forKey: "user_email") ?? "andrew_ainsley@yourdomain.com"
        

        let savedImageData = UserDefaults.standard.data(forKey: "user_profile_image")
        let profileImage = savedImageData != nil ? UIImage(data: savedImageData!) : UIImage(named: "av")


        let menuOptions = [
            ProfileSettings.MenuOption(title: "Edit Profile", icon: "person", type: .navigation),
            ProfileSettings.MenuOption(title: "Notification", icon: "bell", type: .navigation),
            ProfileSettings.MenuOption(title: "Download", icon: "square.and.arrow.down", type: .navigation),
            ProfileSettings.MenuOption(title: "Security", icon: "lock.shield", type: .navigation),
            ProfileSettings.MenuOption(title: "Language", icon: "globe", type: .detail(value: "English (US)")),
            ProfileSettings.MenuOption(title: "Dark Mode", icon: "eye", type: .toggle(isOn: UserDefaults.standard.bool(forKey: "dark_mode_enabled"))),
            ProfileSettings.MenuOption(title: "Help Center", icon: "info.circle", type: .navigation),
            ProfileSettings.MenuOption(title: "Privacy Policy", icon: "shield.lefthalf.filled", type: .navigation)
        ]
        
        let response = ProfileSettings.Fetch.Response(
            name: savedName,
            email: savedEmail,
            profileImage: profileImage,
            menuOptions: menuOptions
        )
        
        presenter?.presentProfile(response: response)
    }
}
