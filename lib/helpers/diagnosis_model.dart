class Diagnosis {
  int? id;
  String? title;
  String? remark;
  String img;

  Diagnosis({
    this.id,
    this.title,
    this.remark,
    required this.img,
  });

  factory Diagnosis.fromMap(Map<String, dynamic> json) => new Diagnosis(
      id: json['id'],
      title: json['title'],
      remark: json['remark'],
      img: json['img']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'remark': remark,
        'img': img,
      };

  Diagnosis.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'],
        remark = json['remark'],
        img = json['img'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
        'remark': remark,
        'img': img,
      };
}
