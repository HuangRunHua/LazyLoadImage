//
//  TableViewCell.swift
//  LazyLoadImage
//
//  Created by Runhua Huang on 2019/7/14.
//  Copyright © 2019 Runhua Huang. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lazyImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
