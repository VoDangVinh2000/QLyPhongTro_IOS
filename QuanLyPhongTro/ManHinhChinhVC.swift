//
//  ManHinhChinhVC.swift
//  QuanLyPhongTro
//
//  Created by Võ Đăng Vĩnh on 20/04/2021.
//  Copyright © 2021 Võ Đăng Vĩnh. All rights reserved.
//

import UIKit

class ManHinhChinhVC: UIViewController {
    //mhcvc
    @IBOutlet weak var vThongTin: UIView!
    @IBOutlet weak var lblTenNguoiDung: UILabel!
    @IBOutlet weak var lblTenDangNhap: UILabel!
    @IBOutlet weak var lblSoPhong: UILabel!
    @IBOutlet weak var lblPhongVip: UILabel!
    @IBOutlet weak var lblPhongThuong: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var idNguoiDung: Int!
    var tenNguoiDung: String!
    var tenDangNhap: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThongTinView()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "QUẢN LÝ PHÒNG TRỌ"
        toanBoPhong()
        soPhongThuong()
        soPhongVip()
    }
    //Thiết lập  UIView
    private func setupThongTinView() {
        vThongTin.layer.shadowColor = UIColor.lightGray.cgColor
        vThongTin.layer.shadowOpacity = 1
        vThongTin.layer.shadowOffset = CGSize.zero
        vThongTin.layer.shadowRadius = 5
        vThongTin.layer.cornerRadius = 5
        vThongTin.layer.masksToBounds = false
        lblTenNguoiDung.text = tenNguoiDung
        lblTenDangNhap.text = tenDangNhap
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = .orange
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "QUẢN LÝ PHÒNG TRỌ"
        //Thiết lập UIbutton , hình ảnh cũng như constraint
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "logout").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(dangXuat), for: .touchUpInside)
        let item = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItem = item
    }
    
    private func toanBoPhong() {
        let sophong = DatabaseModel.getInstance().getAllPhong(idNguoiTao: idNguoiDung!)
        lblSoPhong.text = "\(sophong.count)"
    }
    
    private func soPhongThuong() {
        let sophong = DatabaseModel.getInstance().demSoPhongCoDieuKien(idNguoiTao: idNguoiDung, loaiPhongId: 0)
        lblPhongThuong.text = "\(sophong.count)"
    }
    
    private func soPhongVip() {
        let sophong = DatabaseModel.getInstance().demSoPhongCoDieuKien(idNguoiTao: idNguoiDung, loaiPhongId: 1)
        lblPhongVip.text = "\(sophong.count)"
    }
    
    @objc private func dangXuat() {
        let alert = UIAlertController(title: nil, message: "Bạn có chắc muốn đăng xuất?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Có", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Không", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
 //CollectionView cho màn hình chính
extension ManHinhChinhVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Trả về 2 section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Convert with QuanLyCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! QuanLyCell
        if indexPath.item == 0 {
            cell.imageView.image = #imageLiteral(resourceName: "room").withRenderingMode(.alwaysTemplate)
            cell.label.text = "Quản Lý Phòng"
        }
        if indexPath.item == 1 {
            cell.imageView.image = #imageLiteral(resourceName: "guest").withRenderingMode(.alwaysTemplate)
            cell.label.text = "Quản Lý Khách"
        }
        
        return cell
    }
    //Set up layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 28
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Navigation for DanhSachPhongVC and DanhSachKhachVC
        if indexPath.item == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DanhSachPhongVC") as! DanhSachPhongVC
            vc.idNguoiDung = idNguoiDung
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.item == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DanhSachKhachVC") as! DanhSachKhachVC
            vc.idNguoiDung = idNguoiDung
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
