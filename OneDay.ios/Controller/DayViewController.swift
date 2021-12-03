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
    //var toolBar = UIToolbar()
    //var datePicker  = UIDatePicker()
    
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
    
    private lazy var datePicker : UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.autoresizingMask = .flexibleWidth
            if #available(iOS 13, *) {
                datePicker.backgroundColor = .label
            } else {
                datePicker.backgroundColor = .white
            }
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
            return datePicker
        }()
        
        private lazy var toolBar : UIToolbar = {
            let toolBar = UIToolbar()
            toolBar.translatesAutoresizingMaskIntoConstraints = false
            toolBar.barStyle = .default
            toolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneClicked))]
            toolBar.sizeToFit()
            return toolBar
        }()
        
    @objc private func onDoneClicked(picker : UIDatePicker) {
            
        }
        
        @objc private func dateChanged(picker : UIDatePicker) {
            
        }

    @objc private func addDatePicker() {
            self.view.addSubview(self.datePicker)
            self.view.addSubview(self.toolBar)
            
            NSLayoutConstraint.activate([
                self.datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                self.datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                self.datePicker.heightAnchor.constraint(equalToConstant: 300)
            ])
            
            NSLayoutConstraint.activate([
                self.toolBar.bottomAnchor.constraint(equalTo: self.datePicker.topAnchor),
                self.toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                self.toolBar.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    
    /*@objc private func dateSelector() {
        datePicker = UIDatePicker.init()
            datePicker.backgroundColor = UIColor.white
                    
            datePicker.autoresizingMask = .flexibleWidth
            datePicker.datePickerMode = .date
                    
            datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
            datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(datePicker)
                    
            toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.barStyle = .blackTranslucent
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
            toolBar.sizeToFit()
            self.view.addSubview(toolBar)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
            
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
        }
    }

    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem, target: self, action: Selector("someAction"))
        let button = UIBarButtonItem(title: "Date", style: .plain, target: self, action: #selector(self.addDatePicker))
        navigationItem.rightBarButtonItem = button
        
        setupViews()
        setupLayouts()
        oneDayCollectionView.reloadData()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(oneDayCollectionView)
        
        let dateNow: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateNowString = dateFormatter.string(from: dateNow)
        
        currentDay = CurrentDay.insertAndRetrieveDay(date: dateNowString)
        
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



