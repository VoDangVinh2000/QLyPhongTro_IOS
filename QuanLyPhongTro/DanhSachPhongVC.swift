//
//  DanhSachPhongVC.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class DanhSachPhongVC: UITableViewController {
    
    var idNguoiDung: Int!
    var phongModels: [PhongModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up và lấy dữ liệu	 sau khi vừa chạy app
        setupNavigation()
        getAllData()
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "DANH SÁCH PHÒNG"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(them))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "DANH SÁCH PHÒNG"
        getAllData()
    }
    
    private func getAllData() {
        //Mảng kiểu PhongModel
        phongModels = DatabaseModel.getInstance().getAllPhong(idNguoiTao: self.idNguoiDung!) as? [PhongModel]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func them() {
        let alertController = UIAlertController(title: "THÊM PHÒNG MỚI", message: nil, preferredStyle: .alert)
        //Tạo hộp box sau khi ấn nút UIBarButton
        let customView = CustomView()
        alertController.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50).isActive = true
        customView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 16).isActive = true
        customView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -16).isActive = true
        customView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -50).isActive = true
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        alertController.addAction(UIAlertAction(title: "THÊM", style: .default, handler: { (action) in
            
            if customView.textField.text!.isEmpty {
                
            } else {
               
                let phongModel = PhongModel()
                let tenphong = DatabaseModel.getInstance().layTenPhong(tenP: customView.textField.text ?? "")
                if  tenphong == customView.textField.text{
                      Util.alert1Action(title: "Thành công", message: "Đã có tên phòng", view: self, isDismiss: false, isPopViewController: false)
                }
                else{
                    phongModel.tenphong = customView.textField.text!
                    phongModel.trangthai = 0
                    phongModel.songuoi = 0
                    phongModel.ngaydat = "null"
                    phongModel.tienphong = 0
                    phongModel.ngaythanhtoan = "null"
                    phongModel.id_nguoitao = self.idNguoiDung!
                    //Bắt sự kiện khi Switch button được bật hoặc tắt
                    if customView.switchButton.isOn {
                        phongModel.loaiphong = 1
                    } else {
                        phongModel.loaiphong = 0
                    }
                    
                    let isInserted = DatabaseModel.getInstance().themPhong(phongModel)
                    if isInserted {
                        self.getAllData()
                    } else {
                        
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "HUỶ", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension DanhSachPhongVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phongModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhongTBCell
        cell.phongModel = phongModels?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if phongModels?[indexPath.row].trangthai == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SuaThongTinPhongVC") as! SuaThongTinPhongVC
            vc.type = 0
            vc.idPhong = phongModels?[indexPath.row].id
            vc.tenPhong = phongModels?[indexPath.row].tenphong
            vc.loaiphong = phongModels?[indexPath.row].loaiphong
            vc.idNguoiDung = idNguoiDung
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChiTietPhongVC") as! ChiTietPhongVC
            vc.idPhong = phongModels?[indexPath.row].id
            vc.name = phongModels?[indexPath.row].tenphong
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    //delegate uitableview xoá
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let xoaBT = UITableViewRowAction(style: .normal, title: "Xoá") { (action, index) in
            if self.phongModels?[indexPath.row].trangthai == 0 {
                _ = DatabaseModel.getInstance().xoaPhong(idPhong: (self.phongModels?[indexPath.row].id!)!)
                self.phongModels?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let xoaKhach = DatabaseModel.getInstance().xoaKhachTheoIdPhong(idPhong: (self.phongModels?[indexPath.row].id!)!)
                if xoaKhach {
                    _ = DatabaseModel.getInstance().xoaPhong(idPhong: (self.phongModels?[indexPath.row].id!)!)
                    self.phongModels?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        xoaBT.backgroundColor = .red
        return [xoaBT]
    }
    
}

class CustomView: UIView {
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Nhập tên phòng"
        tf.font = UIFont.boldSystemFont(ofSize: 15)
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        return tf
    }()
    
    let phongvipLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Phòng Vip"
        l.font = UIFont.boldSystemFont(ofSize: 15)
        return l
    }()
    
    let switchButton: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(textField)
        self.addSubview(phongvipLabel)
        self.addSubview(switchButton)
        
        let constraints = [
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
            
            switchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            switchButton.rightAnchor.constraint(equalTo: textField.rightAnchor),
            
            phongvipLabel.centerYAnchor.constraint(equalTo: switchButton.centerYAnchor),
            phongvipLabel.leftAnchor.constraint(equalTo: textField.leftAnchor),
        ]

        NSLayoutConstraint.activate(constraints)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
