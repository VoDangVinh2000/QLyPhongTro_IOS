//
//  SuaThongTinPhongVC.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class SuaThongTinPhongVC: UIViewController {
    
    @IBOutlet weak var tfTenPhong: UITextField!
    @IBOutlet weak var swLoaiPhong: UISwitch!
    @IBOutlet weak var tfHoTen: UITextField!
    @IBOutlet weak var tfSDT: UITextField!
    @IBOutlet weak var tfDiaChi: UITextField!
    @IBOutlet weak var tfNgayDat: UITextField!
    @IBOutlet weak var tfTienPhong: UITextField!
    @IBOutlet weak var tfSoNguoi: UITextField!
    @IBOutlet weak var tfNgayThanhToan: UITextField!
    @IBOutlet weak var btnLuu: UIButton!
    
    var datePicker :UIDatePicker!
    var tag: Int!
    var type: Int!
    var idPhong: Int!
    var loaiphong: Int!
    var idNguoiDung: Int!
    var tenPhong: String!
    
    var callBack: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        
        if tenPhong != nil {
            tfTenPhong.text = tenPhong
        }
        
        // Tạo uidatepickerView add vào 2 textfield khi clicked vào
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.init(identifier: "vi")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        
        //Convert input to UIDatePicker
        tfNgayDat.inputView = datePicker
        tfNgayThanhToan.inputView = datePicker
        
        // Tạo 1 toolbar chứa button done để ẩn uipickerView
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        
        tfNgayDat.inputAccessoryView = toolBar
        tfNgayThanhToan.inputAccessoryView = toolBar
        
        // Nếu type = 0 (Phòng đang trống) thì là đặt phòng
        if type == 0 {
            navigationItem.title = "ĐẶT PHÒNG"
            btnLuu.setTitle("ĐẶT PHÒNG", for: .normal)
            btnLuu.addTarget(self, action: #selector(datPhong), for: .touchUpInside)
            tfTenPhong.isUserInteractionEnabled = false
            swLoaiPhong.isUserInteractionEnabled = false
            if loaiphong == 1 {
                swLoaiPhong.isOn = true
            } else {
                swLoaiPhong.isOn = false
            }
        }
        
        // Nếu type = 1 (Phòng đang có người ở) thì là sửa thông tin phòng
        if type == 1 {
            swLoaiPhong.isUserInteractionEnabled = true
            layThongTinPhong()
            layThongTinKhach()
            navigationItem.title = "SỬA THÔNG TIN PHÒNG"
            btnLuu.setTitle("LƯU", for: .normal)
            btnLuu.addTarget(self, action: #selector(suaThongTinPhong), for: .touchUpInside)
            let item = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(huy))
            item.tintColor = .white
            self.navigationItem.rightBarButtonItem = item
        }
    }
    
    private func layThongTinPhong() {
        let phong = DatabaseModel.getInstance().layThongTinPhong(idPhong: idPhong!)
        tfTenPhong.text = phong.tenphong!
        tfNgayDat.text = phong.ngaydat!
        tfTienPhong.text = "\(phong.tienphong!)"
        tfSoNguoi.text = "\(phong.songuoi!)"
        tfNgayThanhToan.text = phong.ngaythanhtoan!
        let loaiPhong = phong.loaiphong!
        if loaiPhong == 1 {
            swLoaiPhong.isOn = true
        } else {
            swLoaiPhong.isOn = false
        }
    }
    
    private func layThongTinKhach() {
        let khach = DatabaseModel.getInstance().layThongTinKhach(idPhong: idPhong!)
        tfHoTen.text = khach.hoten
        tfSDT.text = khach.sdt
        tfDiaChi.text = khach.diachi
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc private func datPhong() {
            let soNguoi:Int? = Int((tfSoNguoi.text)!)
        if tfNgayDat.text!.isEmpty || tfTienPhong.text!.isEmpty || tfSoNguoi.text!.isEmpty || tfNgayThanhToan.text!.isEmpty || tfHoTen.text!.isEmpty || tfSDT.text!.isEmpty || tfDiaChi.text!.isEmpty {
            Util.alert1Action(title: "Lỗi", message: "Vui lòng nhập đầy đủ thông tin", view: self, isDismiss: false, isPopViewController: false)
        }
        else if soNguoi! >  4{
            Util.alert1Action(title: "Thông báo", message: "Phòng không quá 4 người", view: self, isDismiss: false, isPopViewController: false)
        }
        else {
           
            let isUpdated = DatabaseModel.getInstance().datPhong(idPhong: idPhong!, tenPhong: tfTenPhong.text!, ngayDat: tfNgayDat.text!, tienPhong: Int(tfTienPhong.text!) ?? 0, soNguoi: Int(tfSoNguoi.text!) ?? 0, ngayThanhToan: tfNgayThanhToan.text!, trangThai: 1)
            if isUpdated {
            
                    let khach = KhachModel()
                    khach.hoten = tfHoTen.text!
                    khach.sdt = tfSDT.text!
                    khach.diachi = tfDiaChi.text!
                    khach.id_nguoitao = idNguoiDung!
                    khach.id_phong = idPhong!
                    
                    let isInserted = DatabaseModel.getInstance().themKhach(khach)
                    
                    if isInserted {
                        Util.alert1Action(title: "Thành công", message: "Đặt phòng thành công", view: self, isDismiss: false, isPopViewController: true)
                    }
            }
        }
    }
    
    @objc private func suaThongTinPhong() {
        let soNguoi:Int? = Int((tfSoNguoi.text)!)
        let loaiPhong: Int
        if swLoaiPhong.isOn {
            loaiPhong = 1
        } else {
            loaiPhong = 0
        }
        if soNguoi! >  4{
            Util.alert1Action(title: "Thông báo", message: "Phòng không quá 4 người", view: self, isDismiss: false, isPopViewController: false)
        }
        else{
            let suaPhong = DatabaseModel.getInstance().suaThongTinPhong(tenPhong: tfTenPhong.text!, ngayDat: tfNgayDat.text!, tienPhong: Int(tfTienPhong.text!)!, soNguoi: Int(tfSoNguoi.text!)!, ngayThanhToan: tfNgayThanhToan.text!, loaiPhong: loaiPhong, idPhong: idPhong!)
            
            if suaPhong {
                let suaKhach = DatabaseModel.getInstance().suaThongTinKhach(tenKhach: tfHoTen.text!, sdt: tfSDT.text!, diaChi: tfDiaChi.text!, idPhong: idPhong)
                
                if suaKhach {
                    Util.alert1Action(title: "Thành công", message: "Sửa thông tin phòng thành công", view: self, isDismiss: true, isPopViewController: false)
                    callBack?()
                }
            }
        }
      
    }
    
    @objc private func huy() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    //UIdatepicker
    @objc private func datePickerDone() {
        if tag == 1 {
            tfNgayDat.resignFirstResponder()
            dateChanged()
       }
        
        if tag == 2 {
            tfNgayThanhToan.resignFirstResponder()
            dateChanged()
        }
    }
    
    @objc private func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if tag == 1 {
            tfNgayDat.text = dateFormatter.string(from: datePicker.date)
        }
        
        if tag == 2 {
            tfNgayThanhToan.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
}

extension SuaThongTinPhongVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == tfNgayDat {
            tag = 1
        }
        
        if textField == tfNgayThanhToan {
            tag = 2
        }
        
    }
}
