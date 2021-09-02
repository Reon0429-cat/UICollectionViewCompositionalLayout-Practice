//
//  ViewController.swift
//  UICollectionViewCompositionalLayout-Practice
//
//  Created by 大西玲音 on 2021/09/02.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let colors: [UIColor] = [.red, .blue, .green, .yellow, .orange, .purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(
            section: createCollectionLayoutSection()
        )
    }
    
    private func createCollectionLayoutSection() -> NSCollectionLayoutSection {
        // 小さいアイテム縦二つのグループ
        let itemSpacing: CGFloat = 2
        let smallItemLength = (self.view.frame.width - (itemSpacing * 2)) / 3
        let largeItemLength = smallItemLength * 2 + itemSpacing
        
        let smallItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(smallItemLength),
                heightDimension: .absolute(smallItemLength)
            )
        )
        let smallItemVerticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(smallItemLength),
                heightDimension: .absolute(largeItemLength)
            ),
            subitem: smallItem,
            count: 2
        )
        smallItemVerticalGroup.interItemSpacing = .fixed(itemSpacing)
        
        // 小さいアイテムが縦二つならんがグループ(smallItem)を横に三つ並べたグループ
        let smallItemGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(largeItemLength)
            ),
            subitem: smallItemVerticalGroup,
            count: 3
        )
        smallItemGroup.interItemSpacing = .fixed(itemSpacing)
        
        // 大きいアイテムと小さいアイテム二つのグループ
        let largeItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(largeItemLength),
                heightDimension: .absolute(largeItemLength)
            )
        )
        let largeItemLeftGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(largeItemLength)
            ),
            subitems: [largeItem, smallItemVerticalGroup]
        )
        largeItemLeftGroup.interItemSpacing = .fixed(itemSpacing)
        let largeItemRightGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(largeItemLength)
            ),
            subitems: [smallItemVerticalGroup, largeItem]
        )
        largeItemRightGroup.interItemSpacing = .fixed(itemSpacing)
        
        // それぞれのグループを縦に並べたグループ
        let subItems = [largeItemLeftGroup, smallItemGroup, largeItemRightGroup, smallItemGroup]
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(largeItemLength * CGFloat(subItems.count) + itemSpacing * 50)
            ),
            subitems: subItems
        )
        group.interItemSpacing = .fixed(itemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpacing
        return section
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath
        ) as! CustomCollectionViewCell
        guard let color = colors.randomElement() else { fatalError() }
        cell.configure(with: color)
        return cell
    }
    
}
