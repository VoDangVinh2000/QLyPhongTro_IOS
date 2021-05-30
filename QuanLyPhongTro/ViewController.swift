//
//  ViewController.swift
//  QuanLyPhongTro
//
//  Created by VoDangVinh on 5/28/21.
//  Copyright © 2021 VoDangVinh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var txtTaiKhoan: UITextField!
    @IBOutlet weak var txtMatKhau: UITextField!
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnLogin(_ sender: Any) {
        var strTK:String = ""
        var strMK:String = ""
        strTK = txtTaiKhoan.text!
        strMK = txtMatKhau.text!

        if strTK.characters.count == 0{
            Common.thongBao(parent: self, tieuDe: "Thông báo", noiDung: "Vui lòng nhập tài khoản!")
            txtTaiKhoan.becomeFirstResponder()
            return
        }
        if strMK.characters.count == 0{
            Common.thongBao(parent: self, tieuDe: "Thông báo", noiDung: "Vui lòng nhập mật khẩu!")
            txtMatKhau.becomeFirstResponder()
            return
        }
        if strTK == "admin" && strMK == "admin"{
            print(strTK + strMK)
    }
}
}

