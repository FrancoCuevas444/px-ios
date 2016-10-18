//
//  IssuerRowTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 10/17/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class IssuerRowTableViewCell: UITableViewCell {

    @IBOutlet weak var issuerImage: UIImageView!
    func fillCell(issuer: Issuer, bundle: Bundle){
        issuerImage.image = UIImage(named: "issuer_\(issuer._id!)", in: bundle, compatibleWith: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func addSeparatorLineToTop(width: Double){
        var lineFrame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: width, height: 0.5))
        var line = UIView(frame: lineFrame)
        line.alpha = 0.6
        line.backgroundColor = UIColor(red: 153, green: 153, blue: 153)
        addSubview(line)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
