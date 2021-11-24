//
//  ViewController.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-24.
//

import UIKit

class ViewController: UIViewController {
    private let oneDayCollectionView:UICollectionView = {
        
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
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
        
    }()
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 0.0//16.0
        static let itemHeight: CGFloat = 300.0
    }
    
    var tasks: [TaskItem] = []
    var hours: [HourBlock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        populateTasks()
        populateHours()
        oneDayCollectionView.reloadData()
        
        
        /*let view = UIView()
        view.backgroundColor = .white
        
        
        view.addSubview(oneDayCollectionView)
        
        self.view = view*/
        
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
    
    private func populateTasks() {
        tasks = [
            TaskItem(uid: 0, color: 0xFFFFFF, description: "", order: 0, is_hidden: false),
            TaskItem(uid: 0, color: 0x57838D, description: "sleep", order: 1, is_hidden: false),
            TaskItem(uid: 0, color: 0xF3BFB3, description: "work", order: 2, is_hidden: false),
            TaskItem(uid: 0, color: 0x50B4D8, description: "chores", order: 3, is_hidden: false),
            TaskItem(uid: 0, color: 0xCAB3C1, description: "study", order: 4, is_hidden: false),
            TaskItem(uid: 0, color: 0xA7D9C9, description: "leisure", order: 5, is_hidden: false),
            TaskItem(uid: 0, color: 0xD3C0F9, description: "other", order: 6, is_hidden: false)
        ]
    }
    
    private func populateHours() {
        hours = [
            HourBlock(id: 0, time: "12 AM", task: tasks.first!),
            HourBlock(id: 0, time: "1 AM", task: tasks.first!),
            HourBlock(id: 0, time: "2 AM", task: tasks.first!),
            HourBlock(id: 0, time: "3 AM", task: tasks.first!),
            HourBlock(id: 0, time: "4 AM", task: tasks.first!),
            HourBlock(id: 0, time: "5 AM", task: tasks.first!),
            HourBlock(id: 0, time: "6 AM", task: tasks.first!),
            HourBlock(id: 0, time: "7 AM", task: tasks.first!),
            HourBlock(id: 0, time: "8 AM", task: tasks.first!),
            HourBlock(id: 0, time: "9 AM", task: tasks.first!),
            HourBlock(id: 0, time: "10 AM", task: tasks.first!),
            HourBlock(id: 0, time: "11 AM", task: tasks.first!),
            HourBlock(id: 0, time: "12 PM", task: tasks.first!),
            HourBlock(id: 0, time: "1 PM", task: tasks.first!),
            HourBlock(id: 0, time: "2 PM", task: tasks.first!),
            HourBlock(id: 0, time: "3 PM", task: tasks.first!),
            HourBlock(id: 0, time: "4 PM", task: tasks.first!),
            HourBlock(id: 0, time: "5 PM", task: tasks.first!),
            HourBlock(id: 0, time: "6 PM", task: tasks.first!),
            HourBlock(id: 0, time: "7 PM", task: tasks.first!),
            HourBlock(id: 0, time: "8 PM", task: tasks.first!),
            HourBlock(id: 0, time: "9 PM", task: tasks.first!),
            HourBlock(id: 0, time: "10 PM", task: tasks.first!),
            HourBlock(id: 0, time: "11 PM", task: tasks.first!)
        ]
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        //fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: OneDayCollectionViewCell.identifier, for: indexPath) as! OneDayCollectionViewCell
        
        let hour = hours[indexPath.row]
        hourCell.setup(with: hour)
        hourCell.contentView.backgroundColor = UIColor(rgb: hour.task.color)
        
        //let item = indexPath.item
        //let column = item % 4
        
        return hourCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
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
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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


