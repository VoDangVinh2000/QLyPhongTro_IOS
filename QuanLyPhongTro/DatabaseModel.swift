//
//  DatabaseModel.swift
//  QuanLyPhongTro
//
//  Created by Nguyễn Hải Âu on 8/6/20.
//  Copyright © 2020 Nguyễn Hải Âu. All rights reserved.
//

import UIKit

let sharedInstance = DatabaseModel()

class DatabaseModel: NSObject {
    
    var database: FMDatabase?
    //Liên kết đến database
    class func getInstance() -> DatabaseModel {
        if (sharedInstance.database == nil) {
            sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "QuanLyPhongTro.sqlite"))
        }
        return sharedInstance
    }
    //Hàm đăng ký tài khoản
    func dangKyTaiKhoan(_ TaiKhoanModel: TaiKhoanModel) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO nguoidung (tennguoidung, tendangnhap, matkhau) VALUES(?, ?, ?)", withArgumentsIn: [TaiKhoanModel.tennguoidung!, TaiKhoanModel.tendangnhap!, TaiKhoanModel.matkhau!])
        sharedInstance.database!.close()
        return isInserted
    }
    //Hàm đăng nhập
    func dangNhap(tendn: String, matkhau: String) -> TaiKhoanModel {
        sharedInstance.database!.open()
        let result: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM nguoidung where tendangnhap = ? and matkhau = ?", withArgumentsIn: [tendn, matkhau])
        let item = TaiKhoanModel()
        if result != nil {
            while result.next() {
                item.id = Int(result.int(forColumn: "id"))
                item.tennguoidung = String(result.string(forColumn: "tennguoidung")!)
                item.tendangnhap = String(result.string(forColumn: "tendangnhap")!)
                item.matkhau = String(result.string(forColumn: "matkhau")!)
            }
        }
        sharedInstance.database?.close()
        return item
    }
    //Hàm lấy tất cả thông tin phòng vào table view controller DanhsachPhongVC
    func getAllPhong(idNguoiTao: Int) -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM phong WHERE id_nguoitao = ?", withArgumentsIn: [idNguoiTao])

        let itemInfo: NSMutableArray = NSMutableArray ()
        if (resultSet != nil)
        {
            while resultSet.next() {
                let item = PhongModel()
                item.id = Int(resultSet.int(forColumn: "id"))
                item.tenphong = String(resultSet.string(forColumn: "tenphong")!)
                item.trangthai = Int(resultSet.int(forColumn: "trangthai"))
                item.songuoi = Int(resultSet.int(forColumn: "songuoi"))
                item.ngaydat = String(resultSet.string(forColumn: "ngaydat")!)
                item.tienphong = Int(resultSet.int(forColumn: "tienphong"))
                item.ngaythanhtoan = String(resultSet.string(forColumn: "ngaythanhtoan")!)
                item.loaiphong = Int(resultSet.int(forColumn: "loaiphong"))
                itemInfo.add(item)
            }
        }
        sharedInstance.database!.close()
        return itemInfo
    }
    //Hàm lấy loại phòng
    func demSoPhongCoDieuKien(idNguoiTao: Int, loaiPhongId: Int) -> NSMutableArray {
     sharedInstance.database!.open()
     let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM phong WHERE id_nguoitao = ? and loaiphong = ?", withArgumentsIn: [idNguoiTao, loaiPhongId])
     
     let itemInfo: NSMutableArray = NSMutableArray ()
     if (resultSet != nil)
     {
     while resultSet.next() {
     let item = PhongModel()
     item.id = Int(resultSet.int(forColumn: "id"))
     item.tenphong = String(resultSet.string(forColumn: "tenphong")!)
     item.trangthai = Int(resultSet.int(forColumn: "trangthai"))
     item.songuoi = Int(resultSet.int(forColumn: "songuoi"))
     item.ngaydat = String(resultSet.string(forColumn: "ngaydat")!)
     item.tienphong = Int(resultSet.int(forColumn: "tienphong"))
     item.ngaythanhtoan = String(resultSet.string(forColumn: "ngaythanhtoan")!)
     item.loaiphong = Int(resultSet.int(forColumn: "loaiphong"))
     itemInfo.add(item)
     }
     }
     sharedInstance.database!.close()
     return itemInfo
     }
    //Hàm thêm phòng
    func themPhong(_ PhongModel: PhongModel) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO phong (tenphong, trangthai, songuoi, ngaydat, tienphong, ngaythanhtoan, id_nguoitao, loaiphong) VALUES(?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsIn: [PhongModel.tenphong!, PhongModel.trangthai!, PhongModel.songuoi!, PhongModel.ngaydat!, PhongModel.tienphong!, PhongModel.ngaythanhtoan!, PhongModel.id_nguoitao!, PhongModel.loaiphong!])

        sharedInstance.database!.close()
        return isInserted

    }
    //Kiem tra phong da co chua
    func layTenPhong(tenP:String)->String{
          sharedInstance.database!.open()
        let isInserted:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM phong WHERE tenphong = ?", withArgumentsIn: [tenP])
      //  let itemInfo: NSMutableArray = NSMutableArray ()
        var tenPhong : String!
        if (isInserted != nil)
        {
            while isInserted.next() {
                tenPhong = String(isInserted.string(forColumn: "tenphong")!)
            }
        }
        sharedInstance.database!.close()
        return tenPhong ?? ""
    }
    //Hàm đặt phòng khi phòng trống
    func datPhong(idPhong: Int, tenPhong: String, ngayDat: String, tienPhong: Int, soNguoi: Int, ngayThanhToan: String, trangThai: Int) -> Bool {
        sharedInstance.database!.open()
        
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE phong SET tenphong = ?, ngaydat = ?, tienphong = ?, songuoi = ?, ngaythanhtoan = ?, trangthai = ? WHERE id = ?", withArgumentsIn: [tenPhong, ngayDat, tienPhong, soNguoi, ngayThanhToan, trangThai, idPhong])
        
        sharedInstance.database!.close()
        return isUpdated
        
    }
    //Hàm lấy thông tin phòng theo id
    func layThongTinPhong(idPhong: Int) -> PhongModel {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM phong WHERE id = ?", withArgumentsIn: [idPhong])
        let item = PhongModel()
        if resultSet != nil {
            while resultSet.next() {
                item.id = Int(resultSet.int(forColumn: "id"))
                item.tenphong = resultSet.string(forColumn: "tenphong")
                item.ngaydat = resultSet.string(forColumn: "ngaydat")
                item.tienphong = Int(resultSet.int(forColumn: "tienphong"))
                item.songuoi = Int(resultSet.int(forColumn: "songuoi"))
                item.ngaythanhtoan = resultSet.string(forColumn: "ngaythanhtoan")
                item.loaiphong = Int(resultSet.int(forColumn: "loaiphong"))
            }
        }
        sharedInstance.database?.close()
        return item
    }
    //Hàm lấy thông tin khách theo id
    func layThongTinKhach(idPhong: Int) -> KhachModel {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM khachdatphong WHERE id_phong = ?", withArgumentsIn: [idPhong])
        let item = KhachModel()
        if resultSet != nil {
            while resultSet.next() {
                item.id = Int(resultSet.int(forColumn: "id"))
                item.hoten = resultSet.string(forColumn: "hoten")
                item.sdt = resultSet.string(forColumn: "sdt")
                item.diachi = resultSet.string(forColumn: "diachi")
            }
        }
        sharedInstance.database?.close()
        return item
    }
    //Hàm sửa thông tin phòng
    func suaThongTinPhong(tenPhong: String, ngayDat: String, tienPhong: Int, soNguoi: Int, ngayThanhToan: String, loaiPhong: Int, idPhong: Int) -> Bool {
        sharedInstance.database!.open()

        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE PHONG SET tenphong = ?, ngaydat = ?, tienphong = ?, songuoi = ?, ngaythanhtoan = ?, loaiphong = ? WHERE id = ?", withArgumentsIn: [tenPhong, ngayDat, tienPhong, soNguoi, ngayThanhToan, loaiPhong, idPhong])

        sharedInstance.database!.close()
        return isUpdated

    }
    //Hàm sửa thông tin khách
    func suaThongTinKhach(tenKhach: String, sdt: String, diaChi: String, idPhong: Int) -> Bool {
        sharedInstance.database!.open()
        
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE khachdatphong SET hoten = ?, sdt = ?, diachi = ? WHERE id_phong = ?", withArgumentsIn: [tenKhach, sdt, diaChi, idPhong])
        
        sharedInstance.database!.close()
        return isUpdated
        
    }
    //Hàm thay đổi trạng thái phòng, còn trống hay đang có khách ở
    func thayDoiTrangThaiPhong(trangThai: Int, idPhong: Int, ngayThanhToan: String) -> Bool {
        sharedInstance.database!.open()
        
        if trangThai == 0 { // Trả phòng
            let isUpdated = sharedInstance.database!.executeUpdate("UPDATE phong SET trangthai = ?, ngaydat = 'null', tienphong = 0, songuoi = 0, ngaythanhtoan = 'null' WHERE id = ?", withArgumentsIn: [trangThai, idPhong])
            
            return isUpdated
        }
        
        if trangThai == 1 { // Đã thanh toán
            let isUpdated = sharedInstance.database!.executeUpdate("UPDATE phong SET trangthai = ?, ngaythanhtoan = ? WHERE id = ?", withArgumentsIn: [trangThai, ngayThanhToan, idPhong])
            
            return isUpdated
        }
        
        if trangThai == 2 { // Đang nợ
            let isUpdated = sharedInstance.database!.executeUpdate("UPDATE phong SET trangthai = ? WHERE id = ?", withArgumentsIn: [trangThai, idPhong])
            
            return isUpdated
        }
        
        sharedInstance.database!.close()
        return false
    }
    //Sau khi update phòng thì thông tin khách cũng thay đổi theo
    func thayDoiTrangThaiKhachTheoPhong(idPhong: Int) -> Bool {
        sharedInstance.database!.open()
        
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE khachdatphong SET trangthai = 0 WHERE id_phong = ?", withArgumentsIn: [idPhong])
        
        sharedInstance.database!.close()
        return isUpdated
    }
    //Hàm xoá phòng
    func xoaPhong(idPhong: Int) -> Bool {
        sharedInstance.database!.open()

        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM phong WHERE id = ?", withArgumentsIn: [idPhong])
        
        sharedInstance.database!.close()
        return isDeleted

    }
    //Hàm thêm khách
    func themKhach(_ KhachModel: KhachModel) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO khachdatphong (hoten, sdt, diachi, id_nguoitao, id_phong) VALUES(?, ?, ?, ?, ?)", withArgumentsIn: [KhachModel.hoten!, KhachModel.sdt!, KhachModel.diachi!, KhachModel.id_nguoitao!, KhachModel.id_phong!])
        sharedInstance.database!.close()
        return isInserted
        
    }
    //Hàm lấy tất cả thông tin khách
    func getAllKhach(idNguoiTao: Int) -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM khachdatphong WHERE id_nguoitao = ?", withArgumentsIn: [idNguoiTao])
        
        let itemInfo: NSMutableArray = NSMutableArray ()
        if (resultSet != nil)
        {
            while resultSet.next() {
                let item = KhachModel()
                item.id = Int(resultSet.int(forColumn: "id"))
                item.hoten = resultSet.string(forColumn: "hoten")
                item.sdt = resultSet.string(forColumn: "sdt")
                item.diachi = resultSet.string(forColumn: "diachi")
                itemInfo.add(item)
            }
        }
        sharedInstance.database!.close()
        return itemInfo
    }
    //Hàm xoá khách
    func xoaKhach(idKhach: Int) -> Bool {
        sharedInstance.database!.open()
        
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM khachdatphong WHERE id = ?", withArgumentsIn: [idKhach])
        
        sharedInstance.database!.close()
        return isDeleted
        
    }
    //Hàm xoá khách theo id phòng
    func xoaKhachTheoIdPhong(idPhong: Int) -> Bool {
        sharedInstance.database!.open()
        
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM khachdatphong WHERE id_phong = ?", withArgumentsIn: [idPhong])
        
        sharedInstance.database!.close()
        return isDeleted
    }
    //Hàm lấy số phòng
    func laySoPhong(idKhach: Int) -> PhongModel {
        sharedInstance.database!.open()
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT p.tenphong FROM khachdatphong kdp, phong p WHERE kdp.id_phong = p.id AND kdp.id = ?", withArgumentsIn: [idKhach])
        
        let item = PhongModel()
        if (resultSet != nil)
        {
            while resultSet.next() {
                item.tenphong = resultSet.string(forColumn: "tenphong")
            }
        }
        sharedInstance.database!.close()
        return item
    }
    
    
}
