import UIKit

enum ProfileSettings {
    

    enum MenuType {
        case navigation            // standard arrow
        case toggle(isOn: Bool)    // dark mode switch
        case detail(value: String) // language
    }
    
    struct MenuOption {
        let title: String
        let icon: String // SFSymbol name
        let type: MenuType
    }
    
    
    enum Fetch {
        struct Request {}
        
        struct Response {
            let name: String
            let email: String
            let profileImage: UIImage?
            let menuOptions: [MenuOption]
        }
        
        struct ViewModel {
            struct DisplayedSetting {
                let title: String
                let iconImage: UIImage?
                let showChevron: Bool
                let showSwitch: Bool
                let detailText: String?
                let switchState: Bool
            }
            
            let name: String
            let email: String
            let profileImage: UIImage?
            
            let displayedSettings: [DisplayedSetting]
        }
    }
}
