//
//  DangKyVC.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class DangKyVC: UIViewController {
    //dk
    @IBOutlet weak var tfTenNguoiDung: UITextField!
    @IBOutlet weak var tfTenDangNhap: UITextField!
    @IBOutlet weak var tfMatKhau: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    //Button dang ky
    @IBAction func dangKyBTClicked() {
        if tfTenNguoiDung.text!.isEmpty || tfTenDangNhap.text!.isEmpty || tfMatKhau.text!.isEmpty {
            Util.alert1Action(title: "Lỗi", message: "Vui lòng nhập đầy đủ thông tin!", view: self, isDismiss: false, isPopViewController: false)
        } else {
            let taikhoan = TaiKhoanModel()
            taikhoan.tennguoidung = tfTenNguoiDung.text
            taikhoan.tendangnhap = tfTenDangNhap.text
            taikhoan.matkhau = tfMatKhau.text
            //Thêm dữ liệu vào database
            let isInserted = DatabaseModel.getInstance().dangKyTaiKhoan(taikhoan)
            if isInserted {
                Util.alert1Action(title: "Thành công", message: "Tạo tài khoản thành công.", view: self, isDismiss: false, isPopViewController: true)
            } else {
                Util.alert1Action(title: "Lỗi", message: "Thất bại. Vui lòng thử lại!", view: self, isDismiss: false, isPopViewController: false)
            }
        }
    }
    
}
