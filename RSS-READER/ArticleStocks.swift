//
//  ArticleStocks.swift
//  RSS-READER
//
//  Created by FS on 2016/08/24.
//  Copyright © 2016年 shigeru arayama. All rights reserved.
//

import UIKit

class ArticleStocks: NSObject {
    static let sharedInstance = ArticleStocks()
    var myArticles: Array<Article> = []
    
    func addArticleStocks(article: Article) {
        self.myArticles.insert(article, atIndex: 0)
        saveArticle()
    }
    
    func getMyArticles(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let articles = defaults.objectForKey("myArticles") as? Array<Dictionary<String, String>> {
            for dic in articles {
                var article = ArticleStocks.convertArticleModel(dic)
                self.myArticles.append(article)
            }
        }
    }
    
    func saveArticle(){
        var tmpArticles: Array<Dictionary<String, AnyObject>> = []
        for myArticle in self.myArticles {
            var articleDic = ArticleStocks.convertDictionary(myArticle)
            tmpArticles.append(articleDic)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tmpArticles, forKey: "myArticles")
        defaults.synchronize()
    }
    
    func removeMyArticle(index: Int){
        self.myArticles.removeAtIndex(index)
        saveArticle()
    }
    
    class func convertArticleModel(dic: Dictionary<String, String>) -> Article {
        let article = Article()
        article.title = dic["title"]!
        article.descript = dic["descript"]!
        article.date = dic["date"]!
        article.link = dic["link"]!
        return article
    }
    
    
    class func convertDictionary(article: Article) -> Dictionary<String, AnyObject>{
        var dic = Dictionary<String, AnyObject>()
        dic["title"] = article.title
        dic["descript"] = article.descript
        dic["date"] = article.date
        dic["link"] = article.link
        return dic
    }

}
