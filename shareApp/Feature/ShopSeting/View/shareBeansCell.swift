//
//  shareBeansCell.swift
//  shareApp
//
//  Created by xiaomabao on 2016/12/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

class shareBeansCell: UITableViewCell {

    @IBOutlet weak var colorIMage: UIImageView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var record_val: UILabel!
    @IBOutlet weak var record_time: UILabel!
    @IBOutlet weak var record_desc: UILabel!
    var row:NSInteger?
    var model:RecordModel?{
        didSet{
            record_desc.text = model?.recordDesc
            record_time.text = model?.recordTime
            record_val.text = model?.recordVal
            if row == 0 {
                topImage.isHidden   = true
            }else{
                topImage.isHidden   = false
            }
        
            switch model!.recordType {
            case "0":
                record_val.textColor = "ff6363".color
                record_desc.textColor = "555555".color
                colorIMage.image = #imageLiteral(resourceName: "redColor")
                
            case "1":
                record_desc.textColor = "bbbbbb".color
                record_val.textColor = "bbbbbb".color
                colorIMage.image = #imageLiteral(resourceName: "grayColor")
            case "2":
                record_val.textColor = "a6dc6b".color
                record_desc.textColor = "555555".color
                colorIMage.image = #imageLiteral(resourceName: "greenColor")
            default:
                record_desc.textColor = "bbbbbb".color
                record_val.textColor = "bbbbbb".color
                colorIMage.image = #imageLiteral(resourceName: "grayColor")
            }
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
