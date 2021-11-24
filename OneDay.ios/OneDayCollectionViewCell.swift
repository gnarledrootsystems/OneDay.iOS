//
//  OneDayCollectionViewCell.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-24.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

class OneDayCollectionViewCell: UICollectionViewCell {
    private enum Constants {
        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let profileDescriptionVerticalPadding: CGFloat = 8.0
    }
    
    let hourLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
     }
    
    private func setupViews() {
            contentView.clipsToBounds = true
            contentView.backgroundColor = .white

            contentView.addSubview(hourLabel)
        }
    
    private func setupLayouts() {
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        

        // Layout constraints for `usernameLabel`
        NSLayoutConstraint.activate([
            hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            hourLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with hour: HourBlock) {
        hourLabel.text = hour.time
        //name.text = hour.time
    }
}

extension OneDayCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
