class Comments {
  Comments({
    required this.profilePic,
    required this.name,
    required this.uid,
    required this.type,
    required this.text,
    required this.commentId,
    required this.datePublished,
  });
  late  String profilePic;
  late  String name;
  late  String uid;
  late  Typeu type;
  late  String text;
  late  String commentId;
  late  String datePublished;

  Comments.fromJson(Map<String, dynamic> json){
    profilePic = json['profilePic'].toString();
    name = json['name'].toString();
    uid = json['uid'].toString();
    type = json['type'].toString() == Typeu.image.name?Typeu.image:Typeu.text;
    text = json['text'].toString();
    commentId = json['commentId'].toString();
    datePublished = json['datePublished'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['profilePic'] = profilePic;
    data['name'] = name;
    data['uid'] = uid;
    data['type'] = type.name;
    data['text'] = text;
    data['commentId'] = commentId;
    data['datePublished'] = datePublished;
    return data;
  }
}
enum Typeu{text,image}