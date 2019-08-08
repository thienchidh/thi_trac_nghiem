import 'package:thi_trac_nghiem/api/config/config_api.dart';

class ListStudents {
  String lop;
  List<Student> listInfoSinhvien;
  List<Exam> listInfoBaithi;

  ListStudents({this.lop, this.listInfoSinhvien, this.listInfoBaithi});

  ListStudents.fromJson(Map<String, dynamic> json) {
    lop = json['lop'];
    if (json['ListInfoSinhvien'] != null) {
      listInfoSinhvien = List<Student>();
      json['ListInfoSinhvien'].forEach((v) {
        listInfoSinhvien.add(Student.fromJson(v));
      });
    }
    if (json['ListInfoBaithi'] != null) {
      listInfoBaithi = List<Exam>();
      json['ListInfoBaithi'].forEach((v) {
        listInfoBaithi.add(Exam.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lop'] = this.lop;
    if (this.listInfoSinhvien != null) {
      data['ListInfoSinhvien'] =
          this.listInfoSinhvien.map((v) => v.toJson()).toList();
    }
    if (this.listInfoBaithi != null) {
      data['ListInfoBaithi'] =
          this.listInfoBaithi.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Student {
  String maso;
  String name;
  String email;

  Student({this.maso, this.name, this.email});

  Student.fromJson(Map<String, dynamic> json) {
    maso = json['maso'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['maso'] = this.maso;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}

class Exam {
  static const String UPCOMING = 'upcoming';
  static const String RUNNING = 'running';
  static const String FINISHED = 'finished';

  String maLoaiKt;
  String thoiGianBatDau;
  String baoLau;
  String thoiGianKetThuc;
  String lop;
  String status;
  String tenBaiThi;
  String timeserver;

  Exam({this.maLoaiKt,
    this.thoiGianBatDau,
    this.baoLau,
    this.thoiGianKetThuc,
    this.lop,
    this.status,
    this.tenBaiThi,
    this.timeserver});

  Exam.fromJson(Map<String, dynamic> json) {
    maLoaiKt = json['ma_loai_kt'];
    thoiGianBatDau = json['thoi_gian_bat_dau'];
    baoLau = json['bao_lau'];
    thoiGianKetThuc = json['thoi_gian_ket_thuc'];
    lop = json['lop'];
    status = json[STATUS];
    tenBaiThi = json['ten_bai_thi'];
    timeserver = json['timeserver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ma_loai_kt'] = this.maLoaiKt;
    data['thoi_gian_bat_dau'] = this.thoiGianBatDau;
    data['bao_lau'] = this.baoLau;
    data['thoi_gian_ket_thuc'] = this.thoiGianKetThuc;
    data['lop'] = this.lop;
    data[STATUS] = this.status;
    data['ten_bai_thi'] = this.tenBaiThi;
    data['timeserver'] = this.timeserver;
    return data;
  }

  Map<String, String> toMap() {
    final defaultValue = 'null';
    return {
      'bai_thi': maLoaiKt != null ? maLoaiKt : defaultValue,
      'ten_bai_thi': tenBaiThi != null ? tenBaiThi : defaultValue,
      'thoi_gian_bat_dau':
      thoiGianBatDau != null ? thoiGianBatDau : defaultValue,
      'bao_lau': baoLau != null ? baoLau : defaultValue,
      'lop': lop != null ? lop : defaultValue
    };
  }
}
