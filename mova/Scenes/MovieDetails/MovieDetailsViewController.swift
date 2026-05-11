//
//  MovieDetailsViewController.swift
//  mova
//
//  Created by Muhammad Ahsan Rana on 8/5/2026.
//

import Foundation
import UIKit
import SafariServices


enum DetailTab
{
    case trailers
    case moreLikeThis
    case comments
}



@MainActor
protocol MovieDetailsDisplayLogic: AnyObject {
    func displayMovieDetails(viewModel: MovieDetails.FetchMovie.ViewModel)
    func displayComments(viewModel: MovieDetails.FetchComments.ViewModel)
}


class MovieDetailsViewController: UIViewController
{
    
    
    var selectedTab: DetailTab = .trailers
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    
    var movieId: Int = 0
    
    @IBOutlet var tableView: UITableView!
    
    var interactor: MovieDetailsBusinessLogic?
    //var router: MovieDetailsRoutingLogic?
    
    private var viewModel: MovieDetails.FetchMovie.ViewModel?
    private var commentsViewModel: MovieDetails.FetchComments.ViewModel?
        
    var currentViewModel: MovieDetails.FetchMovie.ViewModel? {
        viewModel
    }
    
    private var didSetInitialOffset = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .never
        
        
        tableView.backgroundColor = .background
        tableView.register(TrailerCell.self, forCellReuseIdentifier: TrailerCell.identifier)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(RecommendationCell.self, forCellReuseIdentifier: RecommendationCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000
        
        let request = MovieDetails.FetchMovie.Request(movieId: movieId)
        Task {
            await interactor?.fetchMovieData(request: request)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !didSetInitialOffset else { return }
        didSetInitialOffset = true
        
        tableView.setContentOffset(
            CGPoint(x: 0, y: -tableView.adjustedContentInset.top),
            animated: false
        )
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
        
        setupNavigationBar()
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
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        backButton.tintColor = .white
        
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up.fill"),
            style: .plain,
            target: self,
            action: nil
        )
        
        
        shareButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [shareButton]
        
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
}

extension MovieDetailsViewController: MovieDetailsDisplayLogic {
    func displayMovieDetails(viewModel: MovieDetails.FetchMovie.ViewModel) {
        self.viewModel = viewModel
        
        let headerView = TableHeaderView()
        headerView.configure(with: viewModel.movie)
        
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let estimatedSize = headerView.systemLayoutSizeFitting(targetSize,
                                                             withHorizontalFittingPriority: .required,
                                                             verticalFittingPriority: .fittingSizeLevel)
        
        headerView.frame = CGRect(origin: .zero, size: estimatedSize)
        tableView.tableHeaderView = headerView
        tableView.reloadData()
    }
    
    func displayComments(viewModel: MovieDetails.FetchComments.ViewModel) {
        commentsViewModel = viewModel
        tableView.reloadData()
    }
}


extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .background
        
        let segment = UISegmentedControl(items: ["Trailers", "More Like This", "Comments"])
        
        segment.selectedSegmentIndex = {
            switch selectedTab
            {
            case .trailers: return 0
            case .moreLikeThis: return 1
            case .comments: return 2
            }
        }()
        
        
        segment.addTarget(self, action: #selector(tabChanged(_:)), for: .valueChanged)
        
        headerView.addSubview(segment)
        segment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segment.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            segment.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            segment.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            segment.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    @objc private func tabChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedTab = .trailers
        case 1: selectedTab = .moreLikeThis
        case 2: selectedTab = .comments
        default: break
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .trailers:
            return viewModel?.movie.trailers.count ?? 0
        case .moreLikeThis:
            return 1
        case .comments:
            return commentsViewModel?.displayedComments.count ?? 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedTab {
        case .trailers:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrailerCell.identifier, for: indexPath) as! TrailerCell
            if let trailer = viewModel?.movie.trailers[indexPath.row] {
                cell.configure(with: trailer)
            }
            return cell

        case .comments:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            if let comment = commentsViewModel?.displayedComments[indexPath.row] {
                cell.configure(with: comment)
            }
            return cell
            
        case .moreLikeThis:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationCell.identifier, for: indexPath) as! RecommendationCell
            
            if let data = viewModel?.movie.recommendations {
                cell.configure(with: data)
            }
            
            cell.didSelectMovie = { [weak self] movie in
                guard let self = self else { return }
                
                let router = HomeRouter()
                router.viewController = self
                router.routeToDetail(movieId: movie.id)
            }
            
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch selectedTab {
        case .trailers:
            if let trailer = viewModel?.movie.trailers[indexPath.row],
               let youtubeUrl = trailer.youtubeUrl {
                let safariVC = SFSafariViewController(url: youtubeUrl)
                present(safariVC, animated: true)
            }
        case .moreLikeThis, .comments:
            break
        }
    }
}
