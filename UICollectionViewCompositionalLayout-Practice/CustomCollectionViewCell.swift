//
//  CustomCollectionViewCell.swift
//  UICollectionViewCompositionalLayout-Practice
//
//  Created by 大西玲音 on 2021/09/02.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { String(describing: self) }
    
    func configure(with color: UIColor) {
        self.backgroundColor = color
    }
    
}
