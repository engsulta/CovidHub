//
//  CovidStatisticsTableViewCell.swift
//  CovidHub
//
//  Created by Ahmed Sultan on 10/3/20.
//

import UIKit

class CovidStatisticsTableViewCell: UITableViewCell {

    var isShimmeringRunning: Bool = false
    var statisticsVM: CovidStatisticsCellViewModel? {
        didSet {
            self.layoutIfNeeded()
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
