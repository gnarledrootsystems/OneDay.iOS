//
//  DayViewController.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2021-11-29.
//

import UIKit
import SQLite

class DayViewController: UIViewController {
    var currentDay: DayModel? = nil
    let datePicker = UIDatePicker()
    var defaultTasks: Array<TaskModel> = []

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
    
    @objc func dateChange(datePicker: UIDatePicker) {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        UserDefaults.standard.set(selectedDate, forKey: "CurrentDate")
        
        setupViews()
        setupLayouts()
        oneDayCollectionView.reloadData()
        
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        defaultTasks = CustomHourTask.getAllUsableTasks()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .white
        
        let dateNow: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: dateNow)
        
        let currentDate = UserDefaults.standard.string(forKey: "CurrentDate") ?? today
        let datePickerDate = dateFormatter.date(from: currentDate)!
        
        datePicker.setDate(datePickerDate, animated: true)
        
        navigationItem.titleView = datePicker
        navigationItem.titleView?.tintColor = .white
        
        let buttonOneDay = UIBarButtonItem(title: "OneDay", style: .plain, target: self, action: nil)
        buttonOneDay.tintColor = .white
        navigationItem.leftBarButtonItem = buttonOneDay
        
        let buttonTasks = UIBarButtonItem(title: "Tasks", style: .plain, target: self, action: #selector(customTasksSeque))
        buttonTasks.tintColor = .white
        
        navigationItem.rightBarButtonItem = buttonTasks
        
        navigationController!.setStatusBar(backgroundColor: UIColor.init(rgb: 0x6D6DD9))
        
        setupViews()
        setupLayouts()
        oneDayCollectionView.reloadData()
    }
    
    @objc func customTasksSeque() {
        //self.performSegue(withIdentifier: "test123", sender: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CustomTaskViewDestination = storyboard.instantiateViewController(withIdentifier: "CustomTaskViewStoryBoard") as! CustomTaskViewController //UINavigationController
        CustomTaskViewDestination.modalPresentationStyle = .fullScreen
        self.navigationController!.pushViewController(CustomTaskViewDestination, animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(oneDayCollectionView)
        
        let dateNow: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: dateNow)
        
        let currentDate = UserDefaults.standard.string(forKey: "CurrentDate") ?? today
        
        currentDay = CurrentDay.insertAndRetrieveDay(date: currentDate)
        
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
    }

}

extension DayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return currentDay!.hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: OneDayCollectionViewCell.identifier, for: indexPath) as! OneDayCollectionViewCell
        
        let hour = currentDay!.hours[indexPath.row]
        hourCell.setup(with: hour)
        hourCell.contentView.backgroundColor = UIColor(rgb: hour.task.color)
        
        return hourCell
    }
}

extension DayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let statusBarFrameHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarFrameHeight = self.navigationController!.navigationBar.frame.height
        let window = UIApplication.shared.windows.first
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        
        let navBarHeight = statusBarFrameHeight + navBarFrameHeight + bottomPadding
        
        let height = (view.frame.height - navBarHeight) / 6
        let width = (view.frame.width / 4)
        
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
            
            var hour = self.currentDay?.hours[indexPath.row]
            
            let current_task_id = defaultTasks.firstIndex(where: {$0.uid == hour?.task.uid})
            let next_task_id = current_task_id! + 1
            
            if (next_task_id < defaultTasks.count) {
                hour?.task = defaultTasks[next_task_id]
            } else {
                hour?.task = defaultTasks.first!
            }
            
            currentDay?.hours[indexPath.row] = hour!
            CurrentDay.updateDB(day: currentDay!)
            
            hourCell.setup(with: hour!)
            hourCell.contentView.backgroundColor = UIColor(rgb: hour!.task.color)
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
