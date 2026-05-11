//
//  WelcomeRouter.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 5/5/2026.
//

import Foundation
import UIKit



protocol WelcomeRoutingLogic {
    func routeToHome()
}

class WelcomeRouter: NSObject, WelcomeRoutingLogic{
    
    
    weak var viewController: UIViewController?
    
    func routeToHome() {
        let homeStoryboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        guard let homeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as? HomeScreenViewController else { return }

        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }

        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()

        homeVC.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = homeVC
        router.viewController = homeVC
        router.dataStore = interactor
        homeVC.router = router
        
        
        let profileInteractor = ProfileInteractor()
        let profilePresenter = ProfilePresenter()
        let profileRouter = ProfileRouter()
        
        profileVC.interactor = profileInteractor
        profileInteractor.presenter = profilePresenter
        profilePresenter.viewController = profileVC
        profileRouter.viewController = profileVC
        profileVC.router = profileRouter
        
        

        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)

        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNav, profileNav]

        if let window = viewController?.view.window {
            window.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
