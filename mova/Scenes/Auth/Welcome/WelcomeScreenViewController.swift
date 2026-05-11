//
//  WelcomeScreenViewController.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 29/4/2026.
//

import UIKit


class WelcomeScreenViewController: UIViewController {
    
    
    var router: WelcomeRoutingLogic?
    
    @IBOutlet var getStartedButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let router = WelcomeRouter()
        router.viewController = self
        self.router = router
    }
    
    
    @IBAction func getStartedTapped(_ sender: Any) {
        router?.routeToHome()
    }
    
}



