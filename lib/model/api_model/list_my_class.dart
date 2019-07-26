class ListMyClass {
  String size;
  List<String> listData;

  ListMyClass.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    listData = json['ListData'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['size'] = this.size;
    data['ListData'] = this.listData;
    return data;
  }
}
