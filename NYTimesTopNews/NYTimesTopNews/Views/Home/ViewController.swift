//
//  ViewController.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 17.05.2023.
//

import UIKit
import GridLayout
import NetworkDataAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let service = DataProviderService()
        //let urlString = "https://api.nytimes.com/svc/topstories/v2/arts.json?api-key=chVtlHkl1VlCWdX0ADK9oASsgZsj0HVa"
        
        let imageView = UIImageView()
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        let urlString = "https://static01.nyt.com/images/2023/05/18/arts/18simon-review/18simon-review-thumbLarge.jpg"
        
        
        service.fetchData(from: urlString) { result in
            switch result {
            case .success(let data):
                print("Data fetched")
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
                
            case .failure(let error):
                switch error {
                case .unknown:
                    print("Unknown error occured")
                case .decodeError:
                    print("Decode error occured")
                case .emptyResponse:
                    print("Empty response")
                case .statusCode(let code):
                    print("Error status code: \(code)")
                }
            }
        }
    }
    
    func makeView(_ color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}

