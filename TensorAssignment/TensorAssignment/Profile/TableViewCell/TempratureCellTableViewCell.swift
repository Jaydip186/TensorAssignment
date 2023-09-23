//
//  TempratureCellTableViewCell.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import UIKit

class TempratureCellTableViewCell: UITableViewCell {

    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
