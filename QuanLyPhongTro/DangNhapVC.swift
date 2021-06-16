//
//  DangNhapVC.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class DangNhapVC: UIViewController {
    
    @IBOutlet weak var tfTenDangNhap: UITextField!
    @IBOutlet weak var tfMatKhau: UITextField!
    //cell.imageView.image = #imageLiteral(resourceName: "guest").withRenderingMode(.alwaysTemplate)
    @IBOutlet weak var ivUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
         ivUser.image? = #imageLiteral(resourceName: "user-login").withRenderingMode(.alwaysTemplate)
        setupNavigation()
    }
    //Thiết lập navigation
    func setupNavigation() {
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    //Tắt keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfTenDangNhap.resignFirstResponder()
        tfMatKhau.resignFirstResponder()
    }
    //Navigation clicked button
    @IBAction func dangKyBTClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DangKyVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //Nút đăng ký
    @IBAction func dangNhapBTClicked() {
        //Kiểm tra 2 trường nhập
        if tfTenDangNhap.text!.isEmpty || tfMatKhau.text!.isEmpty {
            Util.alert1Action(title: "Lỗi", message: "Vui lòng nhập đầy đủ thông tin", view: self, isDismiss: false, isPopViewController: false)
        } else {
            let user = DatabaseModel.getInstance().dangNhap(tendn: tfTenDangNhap.text!, matkhau: tfMatKhau.text!)
            if user.tendangnhap != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //Identifier với màn hình chính
                let vc = storyboard.instantiateViewController(withIdentifier: "ManHinhChinhVC") as! ManHinhChinhVC
                vc.idNguoiDung = user.id
                vc.tenNguoiDung = user.tennguoidung
                vc.tenDangNhap = user.tendangnhap
                let navigation = UINavigationController(rootViewController: vc)
                navigation.modalPresentationStyle = .overFullScreen
                DispatchQueue.main.async {
                    self.navigationController?.present(navigation, animated: true, completion: {
                        self.tfTenDangNhap.text = ""
                        self.tfMatKhau.text = ""
                    })
                }
            } else {
                Util.alert1Action(title: "Lỗi", message: "Thông tin đăng nhập không đúng.", view: self, isDismiss: false, isPopViewController: false)
            }
        }
    }
    
    
    
}
