import Foundation
import UIKit



protocol ProfilePresentationLogic {
    func presentProfile(response: ProfileSettings.Fetch.Response)
}

class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileDisplayLogic?
    
    func presentProfile(response: ProfileSettings.Fetch.Response) {
        
        let displayedSettings = response.menuOptions.map { option in
            return ProfileSettings.Fetch.ViewModel.DisplayedSetting(
                title: option.title,
                iconImage: UIImage(systemName: option.icon),
                showChevron: shouldShowChevron(for: option.type),
                showSwitch: shouldShowSwitch(for: option.type),
                detailText: getDetailText(for: option.type),
                switchState: getSwitchState(for: option.type)
            )
        }
        
        let viewModel = ProfileSettings.Fetch.ViewModel(
            name: response.name,
            email: response.email,
            profileImage: response.profileImage,
            displayedSettings: displayedSettings
        )
        
        viewController?.displayProfile(viewModel: viewModel)
    }
    
    private func shouldShowChevron(for type: ProfileSettings.MenuType) -> Bool {
        if case .toggle = type { return false }
        return true
    }

    private func shouldShowSwitch(for type: ProfileSettings.MenuType) -> Bool {
        if case .toggle = type { return true }
        return false
    }

    private func getDetailText(for type: ProfileSettings.MenuType) -> String? {
        if case .detail(let value) = type { return value }
        return nil
    }

    private func getSwitchState(for type: ProfileSettings.MenuType) -> Bool {
        if case .toggle(let isOn) = type { return isOn }
        return false
    }
}
