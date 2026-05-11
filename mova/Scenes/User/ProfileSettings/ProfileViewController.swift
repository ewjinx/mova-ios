//
//  ProfileViewController.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 5/5/2026.
//

import UIKit


@MainActor
protocol ProfileDisplayLogic: AnyObject {
    func displayProfile(viewModel: ProfileSettings.Fetch.ViewModel)
}



class ProfileViewController: UIViewController, ProfileDisplayLogic {
    
    
    
    
    @IBOutlet var profilePicture: UIImageView!
    
    @IBOutlet var emailAddress: UILabel!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var premiumCard: UIView!
    @IBOutlet var tableView: UITableView!
    var interactor: ProfileBusinessLogic?
    var router: ProfileRoutingLogic?
    private var viewModel: ProfileSettings.Fetch.ViewModel?

    var currentViewModel: ProfileSettings.Fetch.ViewModel? {
        viewModel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupPremiumCard()
        setupTableView()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
        
        let request = ProfileSettings.Fetch.Request()
        Task {
            await interactor?.fetchProfile(request: request)
        }
        
        setupNavigationBar()
        navigationItem.title = "Profile"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    
    private func setupNavigationBar() {
        let logoImageView = UIImageView(image: UIImage(named: "mova_logo"))
        logoImageView.contentMode = .scaleAspectFit
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let container = UIView()
        container.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 40),
            container.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let leftItem = UIBarButtonItem(customView: container)
        navigationItem.leftBarButtonItem = leftItem
    }
    
    
    

    private func setupPremiumCard()
    {
        premiumCard.layer.cornerRadius = 24
        premiumCard.layer.borderWidth = 1.5
        premiumCard.layer.borderColor = UIColor.movaRed.cgColor
    }
    
    private func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.separatorStyle = .none
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
    }
    
    

    
    
    
    
    @MainActor
    func displayProfile(viewModel: ProfileSettings.Fetch.ViewModel) {
        self.viewModel = viewModel
        
        profilePicture.image = viewModel.profileImage
        fullName.text = viewModel.name
        emailAddress.text = viewModel.email
        
        tableView.reloadData()
    }

    @objc
    private func darkModeSwitchChanged(_ sender: UISwitch) {
        guard
            let currentViewModel = viewModel,
            currentViewModel.displayedSettings.indices.contains(sender.tag)
        else {
            return
        }

        let selectedItem = currentViewModel.displayedSettings[sender.tag]
        guard selectedItem.showSwitch else { return }

        UserDefaults.standard.set(sender.isOn, forKey: "dark_mode_enabled")
        
        let style: UIUserInterfaceStyle = sender.isOn ? .dark : .light
        
        if let window = view.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.overrideUserInterfaceStyle = style
            }, completion: nil)
        }

        var updatedSettings = currentViewModel.displayedSettings
        updatedSettings[sender.tag] = ProfileSettings.Fetch.ViewModel.DisplayedSetting(
            title: selectedItem.title,
            iconImage: selectedItem.iconImage,
            showChevron: selectedItem.showChevron,
            showSwitch: selectedItem.showSwitch,
            detailText: selectedItem.detailText,
            switchState: sender.isOn
        )

        viewModel = ProfileSettings.Fetch.ViewModel(
            name: currentViewModel.name,
            email: currentViewModel.email,
            profileImage: currentViewModel.profileImage,
            displayedSettings: updatedSettings
        )
        
        tableView.reloadData()
    }



}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.displayedSettings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell,
              let item = viewModel?.displayedSettings[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = item.title
        cell.iconImageView.image = item.iconImage
        
        cell.chevronImageView.isHidden = !item.showChevron
        cell.toggleSwitch.isHidden = !item.showSwitch
        cell.detailLabel.isHidden = item.detailText == nil
        
        if item.showSwitch {
            cell.toggleSwitch.isOn = item.switchState
        }

        cell.toggleSwitch.tag = indexPath.row
        cell.toggleSwitch.removeTarget(nil, action: nil, for: .valueChanged)
        cell.toggleSwitch.addTarget(self, action: #selector(darkModeSwitchChanged(_:)), for: .valueChanged)
        
        if let detail = item.detailText {
            cell.detailLabel.text = detail
        }
        
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel?.displayedSettings[indexPath.row] else { return }

        if item.title == "Edit Profile" {
            router?.routeToEditProfile()
        }
    }
}
