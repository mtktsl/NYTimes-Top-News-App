//
//  ViewController.swift
//  NYTimesTopNews
//
//  Created by Metin Tarık Kiki on 17.05.2023.
//

import UIKit
import GridLayout

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let label = UILabel()
        label.text = "TEST TITLE"
        
        let label2 = UILabel()
        label2.text = "TEST BODY"
        
        
        let grid = Grid.horizontal {
            Constant(value: 75) {
                makeView(.systemBlue)
            }
            
            Star(value: 1) {
                Grid.vertical {
                    Star(value: 1) {
                        label
                        label2
                    }
                }
            }
        }
        
        grid.frame = CGRect(x: 10,
                            y: 100,
                            width: view.bounds.size.width - 20,
                            height: 50)
        
        
        
        view.addSubview(grid)
    }
    
    func makeView(_ color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}

