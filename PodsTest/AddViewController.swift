//
//  AddViewController.swift
//  PodsTest
//
//  Created by ChoJae youn on 2016. 9. 28..
//  Copyright © 2016년 ChoJae youn. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var _tfMoney: UITextField!
    @IBOutlet weak var _itemPicker: UIPickerView!
    @IBOutlet weak var _segmentedControl: UISegmentedControl!
    
    var _vMoney: String = ""
    var _today: String?
    var _plusminus: String = "-";
    
    var _selectID: Int = 0
    var _itemList: Array<String> = Array<String>()
    var _isInOut: Bool = false // true = +, false = minus
    var _itemColor: UIColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 255)
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DB.initDatabase()
        print("count : \(DB.countColumn())")
        
        _itemList = DB.getItemList(DB.SELECT_ITEM_LIST)
        print("select : \(DB.SELECT_ITEM_LIST)" )
        
        let _date = NSDate()
    
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_kr")
        formatter.timeZone = NSTimeZone(name: "KST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        _today = formatter.stringFromDate(_date)
        print("date : \(_today!)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectDatePicker(sender: UIDatePicker) {
        
        let datePicker = sender
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_kr")
        formatter.timeZone = NSTimeZone(name: "KST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        _today = formatter.stringFromDate(datePicker.date)
        
        print("select date : \(formatter.stringFromDate(datePicker.date))")
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("int : \(row)")
        print("name : \(_itemList[row])")
        _selectID = row
    }
    
    @IBAction func saveLedger(sender: AnyObject) {
        _vMoney = _tfMoney.text!
        print("write : \(_vMoney.characters.count)")
        let _input : Int = _vMoney.characters.count
        if _input > 0 {
            
            let query: String = "INSERT INTO \(DB.NAME_LEDGER) (state, date, money, plusminus) VALUES (:state, :date, :money, :plusminus)"
            var paramDictionary = [NSObject:AnyObject]()
            
            paramDictionary["state"] = _itemList[_selectID]
            paramDictionary["date"] = _today
            paramDictionary["money"] = _vMoney
            paramDictionary["plusminus"] = _plusminus
            
            var result: Bool = DB.insertData(query, paramDictionary: paramDictionary)
            
            if result {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                createAlert("", message: "다시 시도해주세요!", btnTitle: "확인")
            }
            
        } else {
            createAlert("", message: "금액을 입력해주세요!", btnTitle: "확인")
        }
        
    }
    
    func createAlert(title: String, message: String, btnTitle: String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle(btnTitle)
        alert.show()
    }
    
    func numberOfComponentInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent: Int) -> Int{
        return _itemList.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _itemList[row]
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController() {
            print("back")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("herehere")
        _itemList.removeAll()
        _itemList = DB.getItemList(DB.SELECT_ITEM_LIST)
        
        _itemPicker.reloadAllComponents()
        
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.adjustsFontSizeToFitWidth = true
        let titleData = _itemList[row]
        let itemName = NSAttributedString(string: titleData as! String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:_itemColor])
        pickerLabel.attributedText = itemName
        pickerLabel.textAlignment = NSTextAlignment.Center
        
//        print("itemName : \(itemName)")
        
        return pickerLabel
    }
    
    @IBAction func segmentedAction(sender: UISegmentedControl) {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            _isInOut = false
            _plusminus = "-"
            _itemColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 255)
            
        } else {
            _isInOut = true
            _plusminus = "+"
            _itemColor = UIColor.init(red: 0, green: 0, blue: 255, alpha: 255)
        }
        print("\(_plusminus)")
        _itemPicker.reloadAllComponents()
    }
}
