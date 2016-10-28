//
//  Const.swift
//  PodsTest
//
//  Created by ChoJae youn on 2016. 9. 29..
//  Copyright © 2016년 ChoJae youn. All rights reserved.
//

import Foundation
import FMDB

class DB {
    static let NAME_LEDGER: String = "ledger"
    static let NAME_LEDGER_ITEM_LIST: String = "itemlist"
    static let NAME_LEDGER_TOTAL: String = "total"
    
    static let CREATE_TABLE_LEDGER: String = "CREATE TABLE IF NOT EXISTS \(NAME_LEDGER) (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
    "state TEXT, date TEXT NOT NULL, money INTEGER NOT NULL, plusminus TEXT NOT NULL);"
    
    static let CREATE_TABLE_LEDGER_ITEM_LIST: String = "CREATE TABLE IF NOT EXISTS \(NAME_LEDGER_ITEM_LIST) (" + "id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);"
    
    static let CREATE_TABLE_LEDGER_TOTAL: String = "CREATE TABLE IF NOT EXISTS \(NAME_LEDGER_TOTAL) (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, money INTEGER);"
    
    static let SELECT_ITEM_LIST: String = "SELECT * FROM \(NAME_LEDGER_ITEM_LIST);"
    
    static func setDBObject() -> FMDatabase{
        var _fmdb: FMDatabase = FMDatabase.init()
        let _fileManager = NSFileManager.defaultManager()
        if !_fileManager.fileExistsAtPath(returnDBPath()) {
            _fmdb = FMDatabase(path: returnDBPath())
            print("db create")
        }
        return _fmdb
    }
    
    static func returnDBPath() -> String{
        let _dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let _docsDir = _dirPath[0] as String
        
        let _dbName = "/\(NAME_LEDGER).db"
        
        let _dbPath = _docsDir.stringByAppendingString(_dbName)
        return _dbPath
    }
    
    static func initDatabase() -> Void {
            let _fmdb = setDBObject()
            if _fmdb.open() {
                print("open")
                _fmdb.executeStatements(CREATE_TABLE_LEDGER)
                _fmdb.executeStatements(CREATE_TABLE_LEDGER_ITEM_LIST)
                _fmdb.executeStatements(CREATE_TABLE_LEDGER_TOTAL)
                
                let insertQuery = "INSERT INTO \(NAME_LEDGER_ITEM_LIST) (name) VALUES (:name)"
                var paramDictionary = [NSObject:AnyObject]()
                
                paramDictionary["name"] = "월급"
                _fmdb.executeUpdate(insertQuery, withParameterDictionary: paramDictionary)
                paramDictionary["name"] = "보험료"
                let result = _fmdb.executeUpdate(insertQuery, withParameterDictionary: paramDictionary)
                
                if result {
                    print("성공")
                } else {
                    print("실패")
                }
                
//                insertData(_fmdb, query: insertQuery, paramDictionary: paramDictionary);
            } else {
                print("no open")
            }
            _fmdb.close()

        
    }
    
    static func insertData(query: String, paramDictionary: [NSObject:AnyObject]) -> Bool{
        var _fmdb = FMDatabase(path: returnDBPath())
        var result = false
        if _fmdb.open() {
            result = _fmdb.executeUpdate(query, withParameterDictionary: paramDictionary)
            
            if result {
                print("성공")
            } else {
                print("실패")
            }
        }
        _fmdb.close()
        
        return result
    }
    
    static func countColumn() -> Int{
        var result: Int = 0
            let _fmdb = setDBObject()
            do {
//                let res: FMResultSet = try _fmdb.executeQuery("SELECT COUNT (*) FROM \(NAME_LEDGER_ITEM_LIST);", values: nil)
                
                let res: FMResultSet = try _fmdb.executeQuery("SELECT * FROM \(NAME_LEDGER_ITEM_LIST);", values: nil)
                
                    while res.next() {
                        result = Int(res.intForColumn("COUNT(name)"))
                    }
                
            } catch let error as NSError{
                print("Error : \(error.description)")
            }
        return result
    }
    
    
    static func getItemList(query: String) -> Array<String>{
        var itemList: Array<String> = Array<String>()
            var _fmdb = FMDatabase(path: returnDBPath())
            print("db create")
            if _fmdb.open() {
                do {
                let result = try _fmdb.executeQuery(query, values: nil)
                while result.next() == true {
                    let itemName = result.stringForColumn("name")
                    itemList.append(itemName)
                }
                } catch let error as NSError{
                    print("Error : \(error.description)")
                }
            }
            _fmdb.close()
        
        return itemList
    }
    
    static func getItemID(query: String) -> Int {
        var itemID: Int32 = 0
        var _fmdb = FMDatabase(path: returnDBPath())
        if _fmdb.open() {
            do {
                let result = try _fmdb.executeQuery(query, values: nil)
                while result.next() == true {
                    itemID = result.intForColumn("id")
                }
            } catch let error as NSError{
                print("Error : \(error.description)")
            }
        }
        _fmdb.close()
        
        return Int(itemID)
    }
    
    static func getTodayList(date: NSDate) -> Array<ViewController.LedgerItem>{
        var _tempList: Array<ViewController.LedgerItem> = []
        
        var _fmdb = FMDatabase(path: returnDBPath())
        let query = "SELECT * FROM \(NAME_LEDGER) WHERE date=(:date)"
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_kr")
        formatter.timeZone = NSTimeZone(name: "KST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let _today = formatter.stringFromDate(date)
        
        var paramDictionary = [NSObject:AnyObject]()
        paramDictionary["date"] = _today
        if _fmdb.open() {
            do {
                let result = try _fmdb.executeQuery(query, withParameterDictionary: paramDictionary)
                while result.next() == true {
                    
                    _tempList.append(ViewController.LedgerItem.init(state: result.stringForColumn("state"), date: result.stringForColumn("date"), money: Int(result.intForColumn("money")), plusminus: result.stringForColumn("plusminus")))
                }
            } catch let error as NSError{
                print("Error : \(error.description)")
            }
        }
        _fmdb.close()
        
        print("tempList size : \(_tempList.count)")
        
        return _tempList
    }
    
    static func getMonthTotalList(date: NSDate) -> Array<ViewController.LedgerItem>{
        var _tempList: Array<ViewController.LedgerItem> = []
        
        var _fmdb = FMDatabase(path: returnDBPath())
        let query = "SELECT * FROM \(NAME_LEDGER)"
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_kr")
        formatter.timeZone = NSTimeZone(name: "KST")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let _today = formatter.stringFromDate(date)
        
        var paramDictionary = [NSObject:AnyObject]()
        paramDictionary["date"] = _today
        
        
        let _month: String = _today.substringWithRange(Range<String.Index>(start: _today.startIndex.advancedBy(5), end: _today.startIndex.advancedBy(7)))

        print("temp : \(_month)")
        
        if _fmdb.open() {
            do {
                let result = try _fmdb.executeQuery(query, withParameterDictionary: paramDictionary)
                while result.next() == true {
                    let _tempMonth = result.stringForColumn("date")
                    let _tempMonthSub = _tempMonth.substringWithRange(Range<String.Index>(start: _tempMonth.startIndex.advancedBy(5), end: _tempMonth.startIndex.advancedBy(7)))
                    
                    print("temp month : \(_tempMonthSub)")
                    
                    if(_month == _tempMonthSub) {
                        _tempList.append(ViewController.LedgerItem.init(state: result.stringForColumn("state"), date: result.stringForColumn("date"), money: Int(result.intForColumn("money")), plusminus: result.stringForColumn("plusminus")))
                    }
                }
            } catch let error as NSError{
                print("Error : \(error.description)")
            }
        }
        _fmdb.close()
        
        print("tempList size : \(_tempList.count)")
        
        return _tempList
    }
    
}
