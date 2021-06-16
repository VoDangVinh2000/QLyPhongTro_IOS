//
//  KhachTBCell.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class KhachTBCell: UITableViewCell {

    @IBOutlet weak var iconUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblSoPhong: UILabel!
    
    var khach: KhachModel? {
        didSet {
            if let hoten = khach?.hoten {
                lblName.text = hoten
            }
            
            if let sdt = khach?.sdt {
                lblPhone.text = "SĐT: \(sdt)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconUser.image = #imageLiteral(resourceName: "user").withRenderingMode(.alwaysTemplate)
    }

}
