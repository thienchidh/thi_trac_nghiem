class ListQuestions {
  String nextId;
  List<Question> listData;

  ListQuestions({this.nextId, this.listData});

  ListQuestions.fromJson(Map<String, dynamic> json) {
    nextId = json['nextId'];
    if (json['ListData'] != null) {
      listData = List<Question>();
      json['ListData'].forEach((v) => listData.add(Question.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['nextId'] = this.nextId;
    if (this.listData != null) {
      data['ListData'] = this.listData.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ListQuestions{nextId: $nextId, listData: $listData}';
  }
}

class Question {
  static const undefinedAnswer = '_';

  String id;
  String content;
  String dapAnA;
  String dapAnB;
  String dapAnC;
  String dapAnD;
  String dapAnE;
  String dapAnF;
  String direction;
  String position;
  String dapAnDung;
  String rate;
  String thuocChuong;

  String answerOfUser;
  bool isFavorite;

  List<String> listDapAn = [];

  int _computeIndex(String x) {
    switch (x?.toLowerCase()) {
      case 'a':
        return 0;
      case 'b':
        return 1;
      case 'c':
        return 2;
      case 'd':
        return 3;
      default:
    }
    return -1;
  }

  int getIndexOfAnswer() => listDapAn.indexOf(answerOfUser);

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    dapAnA = json['dap_an_a'];
    dapAnB = json['dap_an_b'];
    dapAnC = json['dap_an_c'];
    dapAnD = json['dap_an_d'];
    dapAnE = json['dap_an_e'];
    dapAnF = json['dap_an_f'];
    direction = json['direction'];
    position = json['position'];
    dapAnDung = json['dap_an_dung'];
    rate = json['rate'];
    thuocChuong = json['thuoc_chuong'];

    _computeAndInit();
  }

  void _computeAndInit() {
    isFavorite = false;
    answerOfUser = undefinedAnswer;

    final pos = int.parse(position);

    final choice = (int.parse(direction) == -1)
        ? dapAnDung[pos - 1]
        : dapAnDung[dapAnDung.length - pos];

    listDapAn..add(dapAnA)..add(dapAnB)..add(dapAnC)..add(dapAnD);

    final index = _computeIndex(choice);
    dapAnDung = listDapAn[index];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['dap_an_a'] = this.dapAnA;
    data['dap_an_b'] = this.dapAnB;
    data['dap_an_c'] = this.dapAnC;
    data['dap_an_d'] = this.dapAnD;
    data['dap_an_e'] = this.dapAnE;
    data['dap_an_f'] = this.dapAnF;
    data['direction'] = this.direction;
    data['position'] = this.position;
    data['dap_an_dung'] = this.dapAnDung;
    data['rate'] = this.rate;
    data['thuoc_chuong'] = this.thuocChuong;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Question &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              content == other.content &&
              dapAnA == other.dapAnA &&
              dapAnB == other.dapAnB &&
              dapAnC == other.dapAnC &&
              dapAnD == other.dapAnD &&
              dapAnE == other.dapAnE &&
              dapAnF == other.dapAnF &&
              direction == other.direction &&
              position == other.position &&
              dapAnDung == other.dapAnDung &&
              rate == other.rate &&
              thuocChuong == other.thuocChuong &&
              answerOfUser == other.answerOfUser;

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      dapAnA.hashCode ^
      dapAnB.hashCode ^
      dapAnC.hashCode ^
      dapAnD.hashCode ^
      dapAnE.hashCode ^
      dapAnF.hashCode ^
      direction.hashCode ^
      position.hashCode ^
      dapAnDung.hashCode ^
      rate.hashCode ^
      thuocChuong.hashCode ^
      answerOfUser.hashCode;
}
