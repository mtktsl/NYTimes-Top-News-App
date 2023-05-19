//
//  DetailViewController.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import UIKit
import GridLayout
import SafariServices

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "loading"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = DetailViewController
        .createLabel(text: viewModel.getData().title,
                     font: .boldSystemFont(ofSize: 26),
                     numberOfLines: 0)
    
    lazy var authorLabel: UILabel = DetailViewController
        .createLabel(text: viewModel.getData().author,
                     font: .preferredFont(forTextStyle: .subheadline),
                     numberOfLines: 0)
    
    lazy var descriptiponLabel: UILabel = DetailViewController
        .createLabel(text: viewModel.getData().description,
                     font: .preferredFont(forTextStyle: .title2),
                     numberOfLines: 0)
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("See more", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        button.addTarget(viewModel.delegate,
                         action: #selector(onButtonTap(_:)),
                         for: .touchDown)
        
        return button
    }()
    
    lazy var mainGrid = Grid.vertical {
        Constant(value: viewModel.imageHeight) {
            imageView
        }
        Auto(margin: .init(viewModel.labelTopPadding)) {
            titleLabel
            authorLabel
            descriptiponLabel
        }
        Constant(value: viewModel.buttonHeight,
                 margin: .init(viewModel.buttonPadding.top,
                               viewModel.buttonPadding.left,
                               viewModel.buttonPadding.bottom,
                               viewModel.buttonPadding.right)) {
            button
        }
    }
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        
        scrollView.addSubview(mainGrid)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: viewModel.scrollViewPadding.top),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: viewModel.scrollViewPadding.left),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: viewModel.scrollViewPadding.bottom),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: viewModel.scrollViewPadding.right)
        ])
        
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainGrid.setNeedsLayout()
        setupScrollViewContent()
    }
}

extension DetailViewController: DetailViewModelDelegate {
    @objc func onButtonTap(_ sender: Any) {
        let urlString = viewModel.getData().urlString
        if let url = URL(string: urlString ?? "") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
    
    func onDataSuccess(_ data: Data) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
    
    func onDataError() {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(named: "exclamationmark.triangle")
        }
    }
    
}

extension DetailViewController {
    
    static func createLabel(text: String? = nil,
                             font: UIFont,
                             numberOfLines: Int) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.numberOfLines = numberOfLines
        return label
    }
    
    private func setupScrollViewContent() {
        
        let viewWidth = view.bounds.inset(by: view.safeAreaInsets).size.width
        
        let gridSize = mainGrid.sizeThatFits(
            .init(width: viewWidth,
                  height: 0))
        
        let contentSize = viewModel.calculateContentSize(
            viewWidth: viewWidth,
            viewHeight: gridSize.height)
        
        scrollView.contentSize = .init(width: contentSize.0,
                                       height: contentSize.1)
        
        mainGrid.frame = CGRect(x: 0,
                                y: 0,
                                width: scrollView.contentSize.width,
                                height: scrollView.contentSize.height)
    }
}
