//
//  ItemSelectedViewController.swift
//  PodsTest
//
//  Created by ChoJae youn on 2016. 10. 4..
//  Copyright © 2016년 ChoJae youn. All rights reserved.
//

import UIKit

class ItemSelectedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var _btnTopEdit: UIBarButtonItem!
    
    
    var _itemList: Array<String> = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _tableView.dataSource = self
        _tableView.delegate = self
        
        _itemList = DB.getItemList(DB.SELECT_ITEM_LIST)
        
        print("itemsize : \(_itemList.count)")
        var nib = UINib(nibName: "AddViewTblItem", bundle: nil)
        _tableView.registerNib(nib, forCellReuseIdentifier: "cell")

//        _tableView.reloadData()
//        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading he view.
        
//        navigationItem.rightBarButtonItems = [self.editButtonItem(), self.editButtonItem()]
        
        self.navigationController!.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController!.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        
//        self.refreshControl?.addTarget(self, action: #selector(ItemSelectedViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
//    func refresh(){
//        print("refresh method")
//        self._tableView.reloadData()
//        self.refreshControl?.endRefreshing()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection : \(_itemList.count)")
        return _itemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("tableView row : \(indexPath.row)")
        
        let cell: AddViewTblItemCellTableViewCell = _tableView.dequeueReusableCellWithIdentifier("cell") as! AddViewTblItemCellTableViewCell
        
        cell._lbItem.text = _itemList[indexPath.row]
        
//        _tableView.reloadData()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("click event \(indexPath.row)")
    }
    
    /*
     * lysbon edit start
     */
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = _itemList[sourceIndexPath.row]
        _itemList.removeAtIndex(destinationIndexPath.row)
        _itemList.insert(itemToMove, atIndex: destinationIndexPath.row)
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
//            self._tableView.setEditing(true, animated: true)
//            
//            if(self.editing) {
//                print("editing 1 : \(self.editing)")
//                self.navigationController!.navigationItem.rightBarButtonItem?.title = "OK"
//            } else {
//                print("editing 2 : \(self.editing)")
//                self.navigationController!.navigationItem.leftBarButtonItem?.title = "Add"
//                self._tableView .setEditing(false, animated: true)
//                
//            }
//            self.editing = !self.editing
            
            
            
        }
        return [deleteAction]
//        return [deleteAction, editAction]
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return CGFloat.min
//        }
//        return 0
//    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addListItem(sender: UIBarButtonItem) {
        print("addITem")
        self._tableView .setEditing(false, animated: true)
        
//        let alert = UIAlertView(title: nil, message: "로그인 입력폼", delegate: self, cancelButtonTitle: "Cancel")
//        alert.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
//        alert.addA
//        alert.show()

        let alertController = UIAlertController(title: "항목이름", message: "항목을 입력해주세요", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
            print("cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            if let itemName = alertController.textFields?[0].text {
                print("input : \(itemName)")
                DB.initDatabase()
                
                var paramDictionary = [NSObject:AnyObject]()
                paramDictionary["name"] = itemName
                
                let result = DB.insertData("INSERT INTO \(DB.NAME_LEDGER_ITEM_LIST) (name) VALUES (:name)", paramDictionary: paramDictionary)
                
                if result {
                    self._itemList.removeAll()
                    self._itemList = DB.getItemList(DB.SELECT_ITEM_LIST)
                    self._tableView.reloadData()
                } else {
                    print("failed")
                }
            }
        }
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        
        alertController.addTextFieldWithConfigurationHandler({(textfield: UITextField) in textfield.placeholder = "항목 이름"})
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self._tableView.reloadData()
//     
//    }

    @IBAction func changeListOrder(sender: UIBarButtonItem) {
        print("change list")
        self.navigationController!.navigationItem.leftBarButtonItem?.title = "11"
        
        
        if(self.editing) {
            print("editing 1 : \(self.editing)")
            self._tableView .setEditing(true, animated: true)
            self.navigationController!.navigationItem.leftBarButtonItem?.title = "OK"
        } else {
            print("editing 2 : \(self.editing)")
            self.navigationController!.navigationItem.leftBarButtonItem?.title = "FUCK"
            self._tableView .setEditing(false, animated: true)
            
        }
        self.editing = !self.editing
//                self._tableView .reloadData()
    }
//    
//    override func willMoveToParentViewController(parent: UIViewController?) {
//        super.willMoveToParentViewController(parent)
//        print("back2")
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print("back3")
//    }
    
}
