//
//  GridLength.swift
//  GridPanel
//
//  Created by Metin Tarık Kiki on 25.04.2023.
//

import UIKit

public enum GridLength {
    case star(value: CGFloat,
              view: UIView,
              horizontalAlignment: GridHorizontalAlignment = .fill,
              verticalAlignment: GridVerticalAlignment = .fill,
              margin: UIEdgeInsets = .zero)
    
    case constant(value: CGFloat,
                  view: UIView,
                  horizontalAlignment: GridHorizontalAlignment = .fill,
                  verticalAlignment: GridVerticalAlignment = .fill,
                  margin: UIEdgeInsets = .zero)
    
    case auto(view: UIView,
              horizontalAlignment: GridHorizontalAlignment = .fill,
              verticalAlignment: GridVerticalAlignment = .fill,
              maxSize: CGFloat = 0,
              margin: UIEdgeInsets = .zero)
}


public func Star(value: CGFloat,
          horizontalAlignment: GridHorizontalAlignment = .fill,
          verticalAlignment: GridVerticalAlignment = .fill,
          margin: UIEdgeInsets = .zero,
          @GridBuilder content: () -> [UIView] ) -> [GridLength] {
    
    var result = [GridLength]()
    
    for view in content() {
        result.append(.star(value: value,
                            view: view,
                            horizontalAlignment: horizontalAlignment,
                            verticalAlignment: verticalAlignment,
                            margin: margin))
    }
    return result
}

public func Constant(value: CGFloat,
              horizontalAlignment: GridHorizontalAlignment = .fill,
              verticalAlignment: GridVerticalAlignment = .fill,
              margin: UIEdgeInsets = .zero,
              @GridBuilder content: () -> [UIView] ) -> [GridLength] {
    
    var result = [GridLength]()
    
    for view in content() {
        result.append(.constant(value: value,
                            view: view,
                            horizontalAlignment: horizontalAlignment,
                            verticalAlignment: verticalAlignment,
                            margin: margin))
    }
    
    return result
}

public func Auto(horizontalAlignment: GridHorizontalAlignment = .fill,
          verticalAlignment: GridVerticalAlignment = .fill,
          maxSize: CGFloat = 0,
          margin: UIEdgeInsets = .zero,
          @GridBuilder content: () -> [UIView]) -> [GridLength] {
    
    var result = [GridLength]()
    
    for view in content() {
        result.append(.auto(view: view,
                            horizontalAlignment: horizontalAlignment,
                            verticalAlignment: verticalAlignment,
                            maxSize: maxSize,
                            margin: margin))
    }
    
    return result
}
