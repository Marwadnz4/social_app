class MessageModel{
  String? name;
  String? receiverId;
  String? dateTime;
  String? text;
  String? imageUrl;

  MessageModel({
    this.name,
    this.receiverId,
    this.dateTime,
    this.text,
    this.imageUrl,
  });

  MessageModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toMap(){
    return {
      'name':name,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'text':text,
      'imageUrl':imageUrl,
    };
  }
}