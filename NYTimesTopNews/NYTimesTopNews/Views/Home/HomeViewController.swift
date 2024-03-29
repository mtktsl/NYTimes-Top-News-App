//
//  ViewController.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 17.05.2023.
//

import UIKit
import GridLayout
import NetworkDataAPI

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: TopStoryListLayout(
                                                cellHeight: viewModel.cellHeight))
        
        collectionView.register(TopStoryListCell.self,
                                forCellWithReuseIdentifier: TopStoryListCell.reuseIdentifier)
        
        collectionView.backgroundView = logoView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "applogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .systemBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .systemBlue
        navigationController?.navigationBar.isTranslucent = false
        
        viewModel = HomeViewModel(service: DataProviderService())
        TopStoryListCell.cellHeight = viewModel.cellHeight
        title = viewModel.title
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.fetchData()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.setNeedsLayout()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopStoryListCell.reuseIdentifier,
            for: indexPath) as? TopStoryListCell
        else {
            fatalError("Failed to cast TopStoryListCell")
        }
        
        let newsData = viewModel.getNews(indexPath.row)
        
        cell.configure(with: .init(imageSource: newsData.multimedia.last?.urlString,
                                   title: newsData.title,
                                   author: newsData.author))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.getNews(indexPath.row)
        self.navigate(.init(imageSource: data.multimedia.first?.urlString,
                            title: data.title,
                            description: data.description,
                            author: data.author,
                            urlString: data.urlString))
    }
}

extension HomeViewController {
    
    func navigate(_ data: NYDetailPageModel) {
        let vc = DetailViewController()
        vc.viewModel = DetailViewModel(dataModel: data,
                                       service: DataProviderService())
        vc.view.backgroundColor = .white
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showErrorPopUp(message: String) {
        let alertController = UIAlertController(title: "Network Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry",
                                        style: .default) { action in
            self.viewModel.fetchData()
        }
        
        let exitAction = UIAlertAction(title: "Exit",
                                       style: .destructive) { action in
            exit(0)
        }
        
        alertController.addAction(retryAction)
        alertController.addAction(exitAction)
        
        present(alertController, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func onDataError(_ message: String) {
        DispatchQueue.main.async {
            self.showErrorPopUp(message: message)
        }
    }
    
    func onDataSuccess() {
        DispatchQueue.main.async {
            self.logoView.isHidden = true
            self.collectionView.reloadData()
        }
    }
}
