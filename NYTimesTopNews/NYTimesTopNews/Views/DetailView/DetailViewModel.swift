//
//  DetailViewModel.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import Foundation
import NetworkDataAPI

extension DetailViewModel {
    fileprivate enum DetailVMConstants {
        static let title = "NY Times - Top Stories"
        static let imageHeight: Double = 300
        static let scrollViewPadding: (top: Double,
                                       left: Double,
                                       bottom: Double,
                                       right: Double) = (10, 10, 0, 10)
        
        static let labelTopPadding: Double = 20
        
        static let buttonPadding: (top: Double,
                                   left: Double,
                                   bottom: Double,
                                   right: Double) = (50, 10, 0, 10)
        
        static let buttonHeight: Double = 50
    }
}

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    var title: String { get }
    var imageHeight: Double { get }
    var scrollViewPadding: (top: Double,
                            left: Double,
                            bottom: Double,
                            right: Double) { get }
    
    var labelTopPadding: Double { get }
    var buttonPadding: (top: Double,
                        left: Double,
                        bottom: Double,
                        right: Double) { get }
    
    var buttonHeight: Double { get }
    
    func calculateContentSize(viewWidth: Double,
                              viewHeight: Double) -> (Double, Double)
    
    func fetchData()
    func getData() -> NYDetailPageModel
}

protocol DetailViewModelDelegate: AnyObject {
    func onDataSuccess(_ data: Data)
    func onDataError()
    func onButtonTap(_ sender: Any)
}

final class DetailViewModel {
    weak var delegate: DetailViewModelDelegate?
    let service: DataProviderServiceProtocol
    let dataModel: NYDetailPageModel
    
    init(dataModel: NYDetailPageModel,
         service: DataProviderServiceProtocol) {
        self.service = service
        self.dataModel = dataModel
    }
    
    private func fetchImage() {
        service.fetchData(from: dataModel.imageSource ?? "",
                          dataType: Data.self,
                          decode: false) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.delegate?.onDataSuccess(data)
            case .failure(_):
                self.delegate?.onDataError()
            }
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    
    var labelTopPadding: Double {
        return DetailVMConstants.labelTopPadding
    }
    
    var buttonHeight: Double {
        return DetailVMConstants.buttonHeight + buttonPadding.top + buttonPadding.bottom
    }
    
    var buttonPadding: (top: Double, left: Double, bottom: Double, right: Double) {
        return DetailVMConstants.buttonPadding
    }
    
    var title: String {
        return DetailVMConstants.title
    }

    var scrollViewPadding: (top: Double,
                            left: Double,
                            bottom: Double,
                            right: Double) {
        return DetailVMConstants.scrollViewPadding
    }
    
    var imageHeight: Double {
        return DetailVMConstants.imageHeight
    }
    
    func getData() -> NYDetailPageModel {
        return dataModel
    }
    
    func fetchData() {
        fetchImage()
    }
    
    func calculateContentSize(viewWidth: Double,
                              viewHeight: Double) -> (Double, Double) {
        let finalWidth = viewWidth
            - DetailVMConstants.scrollViewPadding.left
            - DetailVMConstants.scrollViewPadding.right
        
        let finalHeight = viewHeight
            + DetailVMConstants.scrollViewPadding.top
            + DetailVMConstants.scrollViewPadding.bottom
        
        return (finalWidth, finalHeight)
    }
}
