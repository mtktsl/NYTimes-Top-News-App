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
                                              collectionViewLayout: TopStoryListLayout(cellHeight: viewModel.cellHeight))
        collectionView.register(TopStoryListCell.self,
                                forCellWithReuseIdentifier: TopStoryListCell.reuseIdentifier)
        collectionView.backgroundView = logoView
        
        return collectionView
    }()
    
    lazy var mainGrid: Grid = {
        return Grid.vertical {
            Star(value: 1) {
                collectionView
            }
        }
    }()
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "applogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel(service: DataProviderService())
        TopStoryListCell.cellHeight = viewModel.cellHeight
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.fetchData()
        
        view.addSubview(mainGrid)
        
        mainGrid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainGrid.topAnchor.constraint(equalTo: view.topAnchor),
            mainGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainGrid.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainGrid.setNeedsLayout()
    }
    
    func navigate(_ data: NYDetailPageModel) {
        let vc = DetailViewController()
        vc.viewModel = DetailViewModel(dataModel: data,
                                       service: DataProviderService())
        vc.view.backgroundColor = .white
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
