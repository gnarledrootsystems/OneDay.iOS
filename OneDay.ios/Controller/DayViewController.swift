//
//  DayViewController.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import UIKit
import SQLite

class DayViewController: UIViewController {
    private let oneDayCollectionView:UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
        
    }()
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 0.0//16.0
        static let itemHeight: CGFloat = 300.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayouts()
        oneDayCollectionView.reloadData()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(oneDayCollectionView)
        
        oneDayCollectionView.dataSource = self
        oneDayCollectionView.delegate = self
        oneDayCollectionView.register(OneDayCollectionViewCell.self,
                                       forCellWithReuseIdentifier: OneDayCollectionViewCell.identifier)
    }
    
    private func setupLayouts() {
        oneDayCollectionView.translatesAutoresizingMaskIntoConstraints = false

                // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            oneDayCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            oneDayCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            oneDayCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            oneDayCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        /*let screenSize: CGRect = UIScreen.main.bounds
        let height = UIApplication.shared.statusBarFrame.height +
              self.navigationController!.navigationBar.frame.height
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height - height
        
        let cellWidth = screenWidth / 4
        let cellHeight = screenHeight / 6
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0*/
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        //fatalError("init(coder:) has not been implemented")
    }
}

extension DayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return defaultHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: OneDayCollectionViewCell.identifier, for: indexPath) as! OneDayCollectionViewCell
        
        let hour = defaultHours[indexPath.row]
        hourCell.setup(with: hour)
        hourCell.contentView.backgroundColor = UIColor(rgb: hour.task.color)
        
        //let item = indexPath.item
        //let column = item % 4
        
        return hourCell
    }
}

extension DayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let statusBarFrameHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarFrameHeight = self.navigationController!.navigationBar.frame.height
        
        let navBarHeight = statusBarFrameHeight + navBarFrameHeight

        let height = (view.frame.height  - navBarHeight) / 6
        let width = (view.frame.width / 4)
        //itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)
        
        return CGSize(width: width, height: height)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 4

        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow

        return floor(finalWidth)
    }
    
    func itemHeight() {
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}

// Click Handler
extension DayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let hourCell = collectionView.cellForItem(at: indexPath) as? OneDayCollectionViewCell {
            var hour = defaultHours[indexPath.row]
            
            let current_task_id = defaultTasks.firstIndex(where: {$0.uid == hour.task.uid})
            let next_task_id = current_task_id! + 1
            
            if (next_task_id < defaultTasks.count) {
                hour.task = defaultTasks[next_task_id]
            } else {
                hour.task = defaultTasks.first!
            }
            
            
            //hour.task = tasks[1]
            defaultHours[indexPath.row] = hour
            hourCell.setup(with: hour)
            hourCell.contentView.backgroundColor = UIColor(rgb: hour.task.color)
        }
        
        print("User tapped on item \(indexPath.row)")
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}



