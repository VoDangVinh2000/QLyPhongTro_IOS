//
//  PhongTBCell.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class PhongTBCell: UITableViewCell {

    @IBOutlet weak var iconPhong: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var iconVip: UIImageView!
    
    var phongModel: PhongModel? {
        didSet {
            if let name = phongModel?.tenphong {
                lblName.text = name
            }
            if let status = phongModel?.trangthai {
                if status == 0 {
                    lblName.textColor = .lightGray
                    lblStatus.text = "Trạng thái: trống"
                    lblStatus.textColor = .lightGray
                    iconPhong.tintColor = .lightGray
                    lblDate.text = "Ngày đặt: null"
                    lblDate.textColor = .lightGray
                }
                if status == 1 {
                    lblName.textColor = .blue
                    lblStatus.text = "Trạng thái: đang có khách"
                    lblStatus.textColor = .blue
                    iconPhong.tintColor = .blue
                    lblDate.text = "Ngày đặt: \(phongModel?.ngaydat ?? "")"
                    lblDate.textColor = .black
                }
                if status == 2 {
                    lblName.textColor = .red
                    lblStatus.text = "Trạng thái: đang nợ"
                    lblStatus.textColor = .red
                    iconPhong.tintColor = .red
                    lblDate.text = "Ngày đặt: \(phongModel?.ngaydat ?? "")"
                    lblDate.textColor = .red
                }
            }
            
            if let loaiPhong = phongModel?.loaiphong {
                if loaiPhong == 1 {
                    DispatchQueue.main.async {
                        self.iconVip.image = #imageLiteral(resourceName: "vip").withRenderingMode(.alwaysOriginal)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.iconVip.image = nil
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconPhong.image = #imageLiteral(resourceName: "room").withRenderingMode(.alwaysTemplate)
    }
}
