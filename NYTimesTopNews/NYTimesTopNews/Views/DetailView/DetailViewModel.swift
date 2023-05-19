//
//  DetailViewModel.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import Foundation
import NetworkDataAPI

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func fetchData()
    func getData() -> NYDetailPageModel
}

protocol DetailViewModelDelegate: AnyObject {
    func onMoreNewsTap()
    func onDataSuccess(_ data: Data)
    func onDataError()
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
        service.fetchData(from: dataModel.urlString ?? "",
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
    func getData() -> NYDetailPageModel {
        return dataModel
    }
    
    func fetchData() {
        fetchImage()
    }
}
