//
//  LightShowTableViewCell.swift
//
//  Created by Daniel Cardona on 12/2/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import UIKit

class MyModelTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(_ entity: MyModelViewModel) {
       nameLabel.text = entity.name
    }
    
}
