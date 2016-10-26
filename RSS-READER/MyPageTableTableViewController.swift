//
//  MyPageTableTableViewController.swift
//  RSS-READER
//
//  Created by FS on 2016/08/24.
//  Copyright © 2016年 shigeru arayama. All rights reserved.
//

import UIKit

class MyPageTableTableViewController: UITableViewController {
    
    var articleStocks = ArticleStocks.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        self.navigationItem.leftBarButtonItem = editButtonItem()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    //セクション数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //セル数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.articleStocks.myArticles.count
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTableViewCell", forIndexPath: indexPath) as! ProfileTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as! ArticleTableViewCell
            let myArticle = self.articleStocks.myArticles[indexPath.row]
            cell.title.text = myArticle.title
            cell.descript.text = myArticle.descript
            let date: NSDate = NSDate.convertDateFromString(myArticle.date)
            cell.date.text = date.convertStringFromDate()
            return cell
        }
    }
    
    //セルの高さを設定
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        } else {
            return 85
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            articleStocks.removeMyArticle(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 0 {
            let article = self.articleStocks.myArticles[indexPath.row]
            self.performSegueWithIdentifier("ShowToArticleWebViewController", sender: article)
        }
    }
    
    //画面遷移時に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleWebViewController = segue.destinationViewController as! ArticleWebViewController
        articleWebViewController.article = sender as! Article!
    }

}
