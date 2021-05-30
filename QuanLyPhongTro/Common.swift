//
//  Common.swift
//  QuanLyPhongTro
//
//  Created by VoDangVinh on 5/30/21.
//  Copyright © 2021 VoDangVinh. All rights reserved.
//

import Foundation
import UIKit
public class Common{
    static func thongBao(parent:UIViewController,tieuDe:String,noiDung:String){
        let alert = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        let btn = UIAlertAction(title: "Đóng", style: .default, handler: nil)
        alert.addAction(btn)
        parent.present(alert, animated: true, completion: nil)
    }
}
