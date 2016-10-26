//
//  ArticleTableView.swift
//  RSS-READER
//
//  Created by FS on 2016/08/22.
//  Copyright © 2016年 shigeru arayama. All rights reserved.
//

import UIKit

@objc protocol ArticleTableViewDelegate{
    func didSelectTableViewCell(article: Article)
}

class ArticleTableView: UITableView, UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate {
    
    weak var customDelegate: ArticleTableViewDelegate?
    //imageMaskViewの背景色
    let blue = UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    var siteName: String!
    var siteImageName: String!
    var color: UIColor!
    
    var elementName = ""
    var articles:Array<Article> = []

    
    //ソースコードでインスタンスを生成した場合
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //プロトコル指定
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(UINib(nibName: "SiteTopTableViewCell", bundle: nil), forCellReuseIdentifier: "SiteTopTableViewCell")
        self.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //セル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.articles.count
        }
    }
    
    //セルの内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SiteTopTableViewCell", forIndexPath: indexPath) as! SiteTopTableViewCell
            cell.siteImageView.image = UIImage(named: self.siteImageName)
            cell.siteName.text = self.siteName
            cell.imageMaskView.backgroundColor = self.color
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as! ArticleTableViewCell
            let article = self.articles[indexPath.row]
            cell.title.text = article.title
            cell.descript.text = article.descript
            let date: NSDate = NSDate.convertDateFromString(article.date)
            cell.date.text = date.convertStringFromDate()
            return cell
        }
    }
    
    //セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 85
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section != 0 {
            let article = articles[indexPath.row]
            self.customDelegate?.didSelectTableViewCell(article)
        }
    }

    func loadRSS(siteURL: String) {
        if let url = NSURL(string: siteURL) {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) -> Void in
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
            })
            task.resume()
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.elementName = elementName
        if self.elementName == "item" {
            let article = Article()
            self.articles.append(article)
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String) {
        let lastArticle = self.articles.last
        if self.elementName == "title" {
            lastArticle?.title += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } else if self.elementName == "description" {
            lastArticle?.descript += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } else if self.elementName == "pubDate" {
            lastArticle?.date += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } else if self.elementName == "link" {
            lastArticle?.link += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_main_queue(), {
            self.reloadData()
        })
    }
    
    
}
