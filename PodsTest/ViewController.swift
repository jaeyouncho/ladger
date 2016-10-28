//
//  ViewController.swift
//  PodsTest
//
//  Created by ChoJae youn on 2016. 9. 27..
//  Copyright © 2016년 ChoJae youn. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    @IBOutlet weak var _calendar: FSCalendar!
    @IBOutlet weak var _tableView: UITableView!

    @IBOutlet weak var _importMoney: UILabel!
    @IBOutlet weak var _exportMoney: UILabel!
    @IBOutlet weak var _totalMoney: UILabel!
    
    var _totalList: Array<LedgerItem> = []
    var _ledgerList: Array<LedgerItem> = []
    var _totalMonthImport: Int = 0
    var _totalMonthExport: Int = 0
    var _extraMoney: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DB.initDatabase()
        
        _calendar.delegate = self
        _calendar.dataSource = self
        
        _tableView.dataSource = self
        _tableView.delegate = self
        
        var nib = UINib(nibName: "LadgerItemView", bundle: nil)
        _tableView.registerNib(nib, forCellReuseIdentifier: "ladgerCell")
        
        _calendar.scrollDirection = .Vertical
        _calendar.appearance.eventColor = UIColor.init(red: 0, green: 255, blue: 255, alpha: 255)
        
        setData(NSDate())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func calendar(calendar: FSCalendar, hasEventForDate date: NSDate) -> Bool {
        var _event: Bool = false
        print("event date : \(date)")
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_kr")
        formatter.timeZone = NSTimeZone(name: "KST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let _eventDate = formatter.stringFromDate(date)
        
        for i in 0 ... (_totalList.count - 1) {
            if (_eventDate == _totalList[i]._date) {
                _event = true
            } else {
                _event = false
            }
        }
        
        return _event
        
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) { // click calendar
        print("date : \(date)")
        
        setData(date)
    }
    
    func calendarCurrentMonthDidChange(calendar: FSCalendar) {
        print("month : \(calendar.currentMonth)")
    }
    
    @IBAction func addConsume(sender: AnyObject) {
        print("add consume")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection : \(_ledgerList.count)")
        return _ledgerList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("click event \(indexPath.row)")
    }
    
    /*
     * lysbon edit start
     */
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    /*
     * lysbon edit end
     */
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {action in
            //handle delete
        }
        
        var editAction = UITableViewRowAction(style: .Normal, title: "Edit") {action in
            //handle edit
        }
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("tableView row : \(indexPath.row)")
        
        let cell: LadgerItemViewCell = self._tableView.dequeueReusableCellWithIdentifier("ladgerCell") as! LadgerItemViewCell
        
        var _itemColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 255)
        if(_ledgerList[indexPath.row]._plusminus == "+") {
            _itemColor = UIColor.init(red: 0, green: 0, blue: 255, alpha: 255)
        } else if (_ledgerList[indexPath.row]._plusminus == "-") {
            _itemColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 255)
        }
        
        cell._lbNameItem.textColor = _itemColor
        cell._lbNameItem.text = _ledgerList[indexPath.row]._state
        cell._lbMoneyItem.text = String(_ledgerList[indexPath.row]._money!) + "원"
        
        return cell
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setData(NSDate())
    }
    
    func setData(pickDate: NSDate) {
        _totalMonthImport = 0
        _totalMonthExport = 0
        _extraMoney = "0"
        
        _totalList.removeAll()
        _ledgerList.removeAll()
        _totalList = DB.getMonthTotalList(pickDate)
        _ledgerList = DB.getTodayList(pickDate)
        
        _tableView.reloadData()
        
        if(_totalList.count > 0) {
            for i in 0 ... (_totalList.count - 1) {
                if _totalList[i]._plusminus! == "+" {
                    _totalMonthImport += Int(_totalList[i]._money!)
                } else if _totalList[i]._plusminus! == "-" {
                    _totalMonthExport += Int(_totalList[i]._money!)
                }
            }
            _importMoney.text = String(_totalMonthImport)
            _exportMoney.text = String(_totalMonthExport)
            _totalMoney.text = String(_totalMonthImport - _totalMonthExport)
        }
    }
    
    class LedgerItem {
        var _state: String?
        var _date: String?
        var _money: Int?
        var _plusminus: String?
        
        init(state: String, date: String, money: Int, plusminus: String) {
            self._state = state
            self._date = date
            self._money = money
            self._plusminus = plusminus
        }
    }
}

