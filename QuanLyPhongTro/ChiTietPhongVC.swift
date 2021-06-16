//
//  ChiTietPhongVC.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class ChiTietPhongVC: UIViewController {
    
    var name: String!
    var idPhong: Int!
    var idKhach: Int!
    
    @IBOutlet weak var lblTenPhong: UILabel!
    @IBOutlet weak var lblLoaiPhong: UILabel!
    @IBOutlet weak var lblNguoiDat: UILabel!
    @IBOutlet weak var lblSdt: UILabel!
    @IBOutlet weak var lblDiaChi: UILabel!
    @IBOutlet weak var lblNgayDat: UILabel!
    @IBOutlet weak var lblTienPhong: UILabel!
    @IBOutlet weak var lblSoNguoi: UILabel!
    @IBOutlet weak var lblNgayThanhToan: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload data
        layThongTinPhong()
        layThongTinKhach()
    }
    
    @IBAction func thanhToan() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        
        let isUpdated = DatabaseModel.getInstance().thayDoiTrangThaiPhong(trangThai: 1, idPhong: idPhong!, ngayThanhToan: result)
        
        if isUpdated {
            Util.alert1Action(title: "Đã thanh toán", message: "", view: self, isDismiss: false, isPopViewController: false)
            layThongTinPhong()
        }
        
    }
    
    @IBAction func traPhong() {
        let isUpdated = DatabaseModel.getInstance().thayDoiTrangThaiPhong(trangThai: 0, idPhong: idPhong!, ngayThanhToan: "")
        
        if isUpdated {
            
            let isDeleted = DatabaseModel.getInstance().xoaKhach(idKhach: idKhach!)

            if isDeleted {
                Util.alert1Action(title: "Đã trả phòng", message: "", view: self, isDismiss: false, isPopViewController: true)
            }
        }
    }
    
    @IBAction func dangNo() {
        let isUpdated = DatabaseModel.getInstance().thayDoiTrangThaiPhong(trangThai: 2, idPhong: idPhong!, ngayThanhToan: "")
        
        if isUpdated {
            Util.alert1Action(title: "Đã xác nhận đang nợ", message: "", view: self, isDismiss: false, isPopViewController: false)
        }
    }
    
    private func layThongTinPhong() {
        let phong = DatabaseModel.getInstance().layThongTinPhong(idPhong: idPhong!)
        lblTenPhong.text = phong.tenphong!
        lblNgayDat.text = phong.ngaydat!
        let tien = phong.tienphong!
        let forrmatter = NumberFormatter()
        forrmatter.groupingSeparator = "."
        forrmatter.numberStyle = .decimal
        let formattedTien = forrmatter.string(from: NSNumber(value: tien))
        lblTienPhong.text = "\(formattedTien ?? "0") VNĐ"
        lblSoNguoi.text = "\(phong.songuoi!)"
        lblNgayThanhToan.text = phong.ngaythanhtoan!
        
        let loaiPhong = phong.loaiphong!
        
        if loaiPhong == 1 {
            lblLoaiPhong.text = "Phòng vip"
        } else {
            lblLoaiPhong.text = "Phòng thường"
        }
        
    }
    
    private func layThongTinKhach() {
        let khach = DatabaseModel.getInstance().layThongTinKhach(idPhong: idPhong!)
        lblNguoiDat.text = khach.hoten!
        lblSdt.text = khach.sdt!
        lblDiaChi.text = khach.diachi!
        self.idKhach = khach.id!
    }
    //Navigation Sua
    private func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "CHI TIẾT PHÒNG"
        let item = UIBarButtonItem(title: "Sửa", style: .plain, target: self, action: #selector(sua))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc private func sua() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SuaThongTinPhongVC") as! SuaThongTinPhongVC
        vc.type = 1
        vc.idPhong = idPhong
        vc.callBack = {
            self.layThongTinPhong()
            self.layThongTinKhach()
        }
        let navigation = UINavigationController(rootViewController: vc)
        navigation.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
}
