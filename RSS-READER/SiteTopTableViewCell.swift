//
//  SiteTopTableViewCell.swift
//  RSS-READER
//
//  Created by FS on 2016/08/23.
//  Copyright © 2016年 shigeru arayama. All rights reserved.
//

import UIKit

class SiteTopTableViewCell: UITableViewCell {
    @IBOutlet weak var siteName: UILabel!
    @IBOutlet weak var imageMaskView: UIView!
    @IBOutlet weak var siteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setSiteImageView()
        setImageMaskView()
        setNameLabel()
    }
    
    func setSiteImageView() {
        self.siteName.contentMode = UIViewContentMode.ScaleAspectFill
        self.siteImageView.layer.masksToBounds = true
    }
    
    //imageMaskViewの装飾
    func setImageMaskView(){
        self.imageMaskView.alpha = 0.6
    }
    
    //nameLabelの装飾
    func setNameLabel(){
        self.siteName.textColor = UIColor.whiteColor()
        self.siteName.textAlignment = NSTextAlignment.Center
        self.siteName.font = UIFont(name: "Helvetica-Light", size: 40)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
