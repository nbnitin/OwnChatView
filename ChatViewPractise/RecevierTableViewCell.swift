//
//  RecevierTableViewCell.swift
//  ChatViewPractise
//
//  Created by Nitin Bhatia on 1/13/21.
//

import UIKit
let CORNER_RADIUS : CGFloat = 8

class RecevierTableViewCell: UITableViewCell {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var txtChatMessage: UITextView!
    @IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDate.edges([.left, .bottom], to: self.bgView, offset: UIEdgeInsets(top: innerSpacing, left: secondaryPadding, bottom: -secondaryPadding, right: 0))
        lblDate.text = "12:00 a.m."
        bgView.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        bgView.layer.cornerRadius = CORNER_RADIUS

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
