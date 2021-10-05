import 'package:group/model/classes/post.dart';

class Group {
  String name;
  String description;
  String logoPath;
  String iconPath;
  List<Post> posts = <Post>[];

  Group({
    required this.name,
    required this.description,
    this.logoPath = '',
    this.iconPath = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'logoPath': logoPath,
        'iconPath': iconPath,
        'posts': posts
      };

  Group.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        logoPath = json['logoPath'],
        iconPath = json['iconPath'],
        posts = json['posts'].map<Post>((e) => Post.fromJson(e)).toList();
}
