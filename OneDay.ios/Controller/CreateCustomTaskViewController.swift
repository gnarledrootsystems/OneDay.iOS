//
//  CreateCustomTaskViewController.swift
//  OneDay.ios
//
//  Created by Dylan Nunns on 2022-04-05.
//

import Foundation
import UIKit
import Combine

class CreateCustomTaskViewController: UIViewController {
    
    var customTaskViewController: CustomTaskViewController!
    
    @IBOutlet weak var TaskNameInput: UITextField!
    @IBOutlet weak var colorDisplayView: UILabel!
    
    var cancellable: AnyCancellable?
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func ShowColorPicker(_ sender: Any) {
        
        let picker = UIColorPickerViewController()
            picker.selectedColor = self.view.backgroundColor!
            
            //  Subscribing selectedColor property changes.
            self.cancellable = picker.publisher(for: \.selectedColor)
                .sink { color in
                    
                    print(color.description)
                    
                    //  Changing view color on main thread.
                    DispatchQueue.main.async {
                        self.colorDisplayView.backgroundColor = color
                    }
                }
            
            self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func SaveCustomTask(_ sender: Any) {
        let task_name = self.TaskNameInput.text
        let selected_color = self.colorDisplayView.backgroundColor
        
        if (selected_color != nil) {
            let rgbColorValue = selected_color?.rgb()

            let customTask: TaskModel = TaskModel(
                uid: nil,
                color: rgbColorValue!,
                description: task_name!,
                display_order: 1,
                is_hidden: false,
                is_deleted: false
            )
            
            CustomHourTask.insertAutoIncrementTask(task: customTask)
        }
        
        dismiss_and_reload()
    }
    
    @IBAction func CancelCustomTask(_ sender: Any) {
        dismiss_and_reload()
    }
    
    func dismiss_and_reload() {
        customTaskViewController.taskList = CustomHourTask.getAllNonDeletedTasks()
        
        customTaskViewController.tableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
}


extension UIColor {
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
            
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
