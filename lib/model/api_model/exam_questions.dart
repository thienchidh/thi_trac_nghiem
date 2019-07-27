import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';

class ExamQuestions {
  String status;
  String mssv;
  String baiThi;
  String listCauHoi;
  String dapAnA;
  String dapAnC;
  String dapAnD;
  String dapAnE;
  String diem;
  List<Question> listCauHoiDetails;

  ExamQuestions(
      {this.mssv,
      this.baiThi,
      this.listCauHoi,
      this.dapAnA,
      this.dapAnC,
      this.dapAnD,
      this.dapAnE,
      this.diem,
      this.listCauHoiDetails});

  ExamQuestions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    mssv = json['mssv'];
    baiThi = json['bai_thi'];
    listCauHoi = json['list_cau_hoi'];
    dapAnA = json['dap_an_a'];
    dapAnC = json['dap_an_c'];
    dapAnD = json['dap_an_d'];
    dapAnE = json['dap_an_e'];
    diem = json['diem'];
    if (json['ListCauHoiDetails'] != null) {
      listCauHoiDetails = List<Question>();
      json['ListCauHoiDetails'].forEach((v) {
        listCauHoiDetails.add(Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['mssv'] = this.mssv;
    data['bai_thi'] = this.baiThi;
    data['list_cau_hoi'] = this.listCauHoi;
    data['dap_an_a'] = this.dapAnA;
    data['dap_an_c'] = this.dapAnC;
    data['dap_an_d'] = this.dapAnD;
    data['dap_an_e'] = this.dapAnE;
    data['diem'] = this.diem;
    if (this.listCauHoiDetails != null) {
      data['ListCauHoiDetails'] =
          this.listCauHoiDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
