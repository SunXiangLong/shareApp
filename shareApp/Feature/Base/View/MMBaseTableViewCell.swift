//
//  MMBaseTableViewCell.swift
//  ShareApp
//
//  Created by liulianqi on 16/7/21.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit
import IBAnimatable
class MMBaseTableViewCell: AnimatableTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
