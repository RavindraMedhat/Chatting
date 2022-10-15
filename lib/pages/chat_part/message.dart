// ignore_for_file: public_member_api_docs, sort_constructors_first

class ImageInChat {
  static String src = "";
  static String sender = "";
}

class userinfo {
  static List chatgrouplist = [];
  static String chatgroup = "";
  static String chatwith = "";
  static String chatwithProfile = "";
  static String username = "";
  static String userProfile = "";
  static String password = "";
}

class Message {
  String ID;
  String Time;
  String Date;
  String Sender;
  String ContentType;
  String Content;

  Message(
      {required this.ID,
      required this.Time,
      required this.Date,
      required this.Sender,
      required this.ContentType,
      required this.Content});

  factory Message.formOBJ(data) {
    return Message(
        ID: data["ID"],
        Time: data["Time"],
        Date: data["Date"],
        Sender: data["Sender"],
        ContentType: data["ContentType"],
        Content: data["Content"]);
  }

  String factoryDes() {
    return '$Sender send message :- $Content at $Time on $Date';
  }
}
