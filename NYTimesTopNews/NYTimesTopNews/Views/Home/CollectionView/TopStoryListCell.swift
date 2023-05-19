//
//  NYListCell.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import UIKit
import GridLayout
import NetworkDataAPI

class TopStoryListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TopStoryListCell"
    static var cellHeight: CGFloat = 150
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "loading"))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 3
        return titleLabel
    }()
    
    lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = .preferredFont(forTextStyle: .body)
        authorLabel.numberOfLines = 1
        return authorLabel
    }()
    
    lazy var spacer: UIView = {
        let spacer = UIView()
        spacer.backgroundColor = .systemGray
        return spacer
    }()
    
    lazy var mainGrid: Grid = {
        return Grid.vertical {
            Star(value: 1) {
                Grid.horizontal {
                    Constant(value: TopStoryListCell.cellHeight) { //Constant area for imageView
                        imageView
                    }
                    Star(value: 3, margin: .init(0, 10)) { //Expand vertical grid to remaining area
                        Grid.vertical {
                            Auto { //Auto resizing for titleLabel
                                titleLabel
                            }
                            Star(value: 1,
                                 horizontalAlignment: .autoRight,
                                 verticalAlignment: .autoBottom) { //Auto resizing for authorLabel
                                authorLabel
                            }
                        }
                    }
                }
            }
            Constant(value: 10, margin: .init(9)) {
                spacer
            }
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentView.addSubview(mainGrid)
        mainGrid.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainGrid.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainGrid.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainGrid.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainGrid.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with listModel: NYListPageModel) {
        downloadImage(from: listModel.imageSource)
        titleLabel.text = listModel.title
        authorLabel.text = listModel.author
        mainGrid.setNeedsLayout()
    }
    
    private func downloadImage(from urlString: String?) {
        guard let urlString = urlString
        else {
            self.imageView.image = UIImage(named: "exclamationmark.triangle")
            return
        }
        
        let dataProvider: DataProviderServiceProtocol = DataProviderService()
        
        dataProvider.fetchData(from: urlString,
                               dataType: Data.self,
                               decode: false) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "exclamationmark.triangle")
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
