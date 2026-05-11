//
//  ViewController.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 29/4/2026.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    
    let loader = MovaLoaderView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = UIColor(named: "BackgroundColor")

        
        
        tabBarController?.tabBar.isHidden = true
        loader.center = CGPoint(x: view.center.x, y: view.center.y + 200)
        view.addSubview(loader)
        
        loader.startAnimating()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loader.stopAnimating()
            self.navigateToWelcome()
        }
                
        
        
        
    }
    
    private func navigateToWelcome() {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeScreenViewController")
        
        if let window = view.window{
            window.rootViewController = welcomeVC
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }


}

