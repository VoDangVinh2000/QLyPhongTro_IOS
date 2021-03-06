//
//  DanhSachKhachVC.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class DanhSachKhachVC: UITableViewController {
    //dsk
    var idNguoiDung: Int?
    var khachArr: [KhachModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        getAllKhach()
    }
    
    private func getAllKhach() {
        khachArr = DatabaseModel.getInstance().getAllKhach(idNguoiTao: idNguoiDung!) as? [KhachModel]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "DANH SÁCH KHÁCH Ở TRỌ"
    }
}

extension DanhSachKhachVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return khachArr?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KhachTBCell
        cell.khach = khachArr?[indexPath.row]
        let phong = DatabaseModel.getInstance().laySoPhong(idKhach: (khachArr?[indexPath.row].id)!)
        cell.lblSoPhong.text = phong.tenphong!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
