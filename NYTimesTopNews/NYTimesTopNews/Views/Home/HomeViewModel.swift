//
//  HomeViewModel.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 19.05.2023.
//

import Foundation
import NetworkDataAPI

extension HomeViewModel {
    fileprivate enum HomeVMConstants {
        static let title = "NY Times - Top Stories"
        
        static let cellHeight: Double = 150
        
        static let unknownErrorMessage = "Unknown connection error."
        static let decodeErrorMessage = "Data decode error occured. Report the issue to the devs."
        static let noResponseMessage = "Unable to connect to the server. Please check your internet connection."
        static let connectionErrorMessage = "Connection error. Code: "
    }
}

protocol HomeViewModelProtocol {
    var numberOfItems: Int { get }
    var delegate: HomeViewModelDelegate? { get set }
    var cellHeight: Double { get }
    var title: String { get }
    
    
    func fetchData()
    func getNews(_ at: Int) -> NYResultModel
}

protocol HomeViewModelDelegate: AnyObject {
    func onDataSuccess()
    func onDataError(_ message: String)
}

final class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    let dataService: DataProviderServiceProtocol
    private var newsData: NYTopModel?
    
    init(service: DataProviderServiceProtocol) {
        dataService = service
    }
    
    private func generateMessageFromError(error: DataProviderServiceError) -> String {
        switch error {
        case .unknown:
            return HomeVMConstants.unknownErrorMessage
        case .decodeError:
            return HomeVMConstants.decodeErrorMessage
        case .noResponse:
            return HomeVMConstants.noResponseMessage
        case .statusCode(let code):
            return HomeVMConstants.connectionErrorMessage + "\(code)"
        }
    }
    
    func fetchNews() {
        dataService.fetchData(from: ApplicationConstants.NYTopStoriesUrl,
                              dataType: NYTopModel.self,
                              decode: true) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                //self.convertData(topData: data)
                newsData = data
                delegate?.onDataSuccess()
            case .failure(let error):
                delegate?.onDataError(generateMessageFromError(error: error))
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    var title: String {
        return HomeVMConstants.title
    }
    
    var numberOfItems: Int {
        return newsData?.results.count ?? 0
    }
    
    var cellHeight: Double {
        return HomeVMConstants.cellHeight
    }
    
    func fetchData() {
        fetchNews()
    }
    
    func getNews(_ at: Int) -> NYResultModel {
        guard let newsData else { fatalError("Nil newsData") }
        if at < 0 || at >= numberOfItems {
            fatalError("Index out of range")
        } else {
            return newsData.results[at]
        }
    }
}
