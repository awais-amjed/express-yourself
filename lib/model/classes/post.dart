class Post {
  String posterName;
  String text;
  String imagePath;
  int likeCount = 0;

  Post({
    required this.posterName,
    this.text = '',
    this.imagePath = '',
  });

  Map<String, dynamic> toJson() => {
        'posterName': posterName,
        'text': text,
        'imagePath': imagePath,
        'likeCount': likeCount,
      };

  Post.fromJson(Map<String, dynamic> json)
      : posterName = json['posterName'],
        text = json['text'],
        imagePath = json['imagePath'],
        likeCount = json['likeCount'];
}
